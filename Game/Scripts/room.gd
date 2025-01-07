extends Node

class_name Room
@export var enemy_scene = [preload("res://Characters/NPC/Bouncer.tscn"),
preload("res://Characters/NPC/Randomer.tscn"),
preload("res://Characters/NPC/Shooter.tscn")]

@export var num_enemies: int = 3  # Number of enemies per room
var enemies = [] # Track spawned enemies
var is_cleared = false
var spawn_areas = []
@export var prev = null
@export var next = null

func set_next(o_next):
	self.next = o_next
	
func set_prev(o_prev):
	self.prev = o_prev

func populate_room():
	if is_cleared:
		return
	for child in get_children():
		if child is PlayerSpawn:
			child.spawn_entities(self)
	for child in get_children():
		if child is spawn:
			enemies += child.spawn_entities(self, enemy_scene)
			spawn_areas.append(child)
	for i in enemies:
		if i.has_signal("enemy_defeated"):
			var result = i.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
			print("Connect result:", result)  # 0 (OK) indicates success
		else:
			print(i)

func _on_enemy_defeated(enemy):
	enemies.erase(enemy)
	print("SIZE ENEMIES",enemies.size())
	if enemies.size() == 0 and not is_cleared:
		is_cleared = true
		Enums.level_layout[get_parent().level_num][1][name] = true
		print("Room cleared:", name)
		unlock_doors()

func unlock_doors():
	for child in get_children():
		if child is Door:
			child.unlock()

func despawn():
	for i in get_children():
		if i is PlayerSpawn:
			for j in i.get_children():
				if j is Player:
					i.remove_child(j)

func next_room():
	var my_parent = get_parent()
	if next != null:
		var rooms = my_parent.get_children()
		for i in rooms:
			if i is Room:
				print("ROOOOOOM")
				i.get_parent().remove_child(i)
				i.despawn()
		var new_room = next
		new_room.populate_room()
		my_parent.add_child(new_room)
	
	
	
