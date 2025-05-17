extends Node

signal door_entered(pos: Vector2)

@export var enemy_scene: Array = [
	preload("res://Characters/NPC/Bouncer.tscn"),
	preload("res://Characters/NPC/Randomer.tscn"),
	preload("res://Characters/NPC/Shooter.tscn")
]

var room_position: Vector2
var level_index: int
var is_cleared: bool = false
var connections := {}
var enemies: Array = []

func populate_room():
	place_doors()

	if is_cleared:
		unlock_doors()
		return

	for child in get_children():
		if child is spawn:
			var new_enemies = child.spawn_entities(self, enemy_scene)
			for e in new_enemies:
				if e.has_signal("enemy_defeated"):
					e.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
				enemies.append(e)

func place_doors():
	var elevator_direction: String = ""
	var angle_map = {
		"up": deg_to_rad(270),
		"down": deg_to_rad(90),
		"left": deg_to_rad(0),
		"right": deg_to_rad(180)
		}

	for dir in connections:
		var anchor = get_node_or_null("door_" + dir)
		if anchor:
			var door = load("res://Game/Scenes/DoorHorizontal.tscn" if dir in ["up", "down"] else "res://Game/Scenes/DoorVertical.tscn").instantiate()
			door.direction = dir
			door.connected_room_pos = connections[dir]
			door.global_position = anchor.global_position
			door.add_to_group("room_doors")
			add_child(door)

			if door.has_node("Area2D"):
				var area = door.get_node("Area2D")
				await get_tree().process_frame
				area.body_entered.connect(func(body):
					if body.name == "player" and not door.is_locked:
						call_deferred("emit_signal", "door_entered", door.connected_room_pos)
				)
	# Elevator placement if needed
	if Enums.level_layout[level_index][room_position].get("has_elevator", false):
		for dir in ["up", "down", "left", "right"]:
			if not connections.has(dir):
				var anchor = get_node_or_null("door_" + dir)
				if anchor:
					var elevator = preload("res://Game/Scenes/Elevator.tscn").instantiate()
					elevator.global_position = anchor.global_position
					elevator.rotation = angle_map.get(dir, 0)
					add_child(elevator)
					if is_cleared:
						elevator.unlock()
					elevator_direction = dir
					break
					
	for dir in ["up", "down", "left", "right"]:
		if not connections.has(dir) and dir != elevator_direction:
			var anchor = get_node_or_null("door_" + dir)
			if anchor:
				var wall = load("res://Game/Scenes/WallPlacer_" + dir + ".tscn").instantiate()
				wall.global_position = anchor.global_position
				add_child(wall)

	if is_cleared:
		await get_tree().process_frame
		unlock_doors()

func _on_enemy_defeated(enemy):
	enemies.erase(enemy)
	if enemies.is_empty():
		is_cleared = true
		Enums.level_layout[level_index][room_position]["cleared"] = true
		unlock_doors()
		if Enums.level_layout[level_index][room_position].get("has_elevator", true):
			for child in get_children():
				if child is Elevator:
					child.unlock()

func unlock_doors():
	for door in get_tree().get_nodes_in_group("room_doors"):
		if door.is_inside_tree() and door.get_parent() == self:
			door.unlock()

func _exit_tree():
	for door in get_tree().get_nodes_in_group("room_doors"):
		if door.get_parent() == self:
			door.remove_from_group("room_doors")
