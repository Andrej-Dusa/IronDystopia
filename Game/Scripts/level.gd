extends Node2D

@export var room_scenes: Array = [
	preload("res://Game/Scenes/room_t_1.tscn"),
	preload("res://Game/Scenes/room_t_2.tscn"),
	preload("res://Game/Scenes/room_t_3.tscn"),
	preload("res://Game/Scenes/room_t_4.tscn"),
	preload("res://Game/Scenes/room_t_5.tscn")
]  # Preload your room scenes
@export var num_rooms: int = 5  # Number of rooms in a floor
@export var level_num: int = 1

@export var rooms: Array = []
var current_room_index: int = 0
# Generate a dungeon floor
func generate_floor(level):
	level_num = level
	Enums.level_layout[level_num] = [[],{}]
	for i in num_rooms:
		# Pick a random room scene
		var room_scene = room_scenes[randi() % room_scenes.size()]
		var room_instance = room_scene.instantiate()
		room_instance.name = "Room%d_lvl_%d" % [i, level_num]
		rooms.append(room_instance)
		# Store the room for future access
		Enums.level_layout[level_num][0].append(room_instance)
		Enums.level_layout[level_num][1][i] = false
	connect_rooms()
	enter_level()

func connect_rooms():
	var size = rooms.size()
	if size > 1:
		for i in size:
			if i == 0 :
				rooms[i].set_next(rooms[i+1])
			elif i == (size-1):
				rooms[i].set_prev(rooms[i-1])
			else:
				rooms[i].set_prev(rooms[i-1])
				rooms[i].set_next(rooms[i+1])

func enter_level():
	if rooms.size() > 0:
		var current_room = rooms[0]
		current_room.populate_room()
		add_child(current_room)
