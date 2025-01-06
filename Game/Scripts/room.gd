extends Node


@export var enemy_scene = [preload("res://Characters/NPC/Bouncer.tscn"),
preload("res://Characters/NPC/Randomer.tscn"),
preload("res://Characters/NPC/Shooter.tscn")]

@export var num_enemies: int = 3  # Number of enemies per room
var enemies  # Track spawned enemies
var is_cleared = false
var spawn_areas = []

func populate_room():
	if is_cleared:
		return

	for child in get_children():
		randomize()
		if child is spawn:
			enemies = child.spawn_entities(self, enemy_scene[randi() % enemy_scene.size()])
			spawn_areas.append(child)
	for i in enemies:
		i.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
			
	#var spawn_points = spawn_areas.get_children()
	#for i in range(num_enemies):
		#if spawn_points.size() > 0:
			#var spawn_point = spawn_points[i % spawn_points.size()]
			#var enemy = enemy_scene.instantiate()
			#enemy.position = spawn_point.global_position
			#add_child(enemy)
			#enemies.append(enemy)
			# Connect to enemy death signal
			#enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))

func _on_enemy_defeated(enemy):
	enemies.erase(enemy)
	if enemies.size() == 0 and not is_cleared:
		is_cleared = true
		Enums.level_layout[get_parent().level_num][1][name] = true
		print("Room cleared:", name)
		unlock_doors()

func unlock_doors():
	for child in get_children():
		if child.name == "Door":
			child.unlock()
