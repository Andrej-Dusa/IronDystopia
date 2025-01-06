extends Node2D

@export var room_scenes: Array = [
	preload("res://Game/Scenes/room_t_1.tscn")
]  # Preload your room scenes
@export var num_rooms: int = 5  # Number of rooms in a floor
@export var level_num: int = 1

@onready var room_container = $RoomContainer

# Generate a dungeon floor
func generate_floor(level):
	level_num = level
	Enums.level_layout[level_num] = [[],{}]
	for i in range(num_rooms):
		# Pick a random room scene
		var room_scene = room_scenes[randi() % room_scenes.size()]
		var room_instance = room_scene.instantiate()
		room_instance.name = "Room%d_lvl_%d" % [i, level_num]
		room_container.add_child(room_instance)

		# Add enemies (handled by the room script)
		room_instance.populate_room()

		# Store the room for future access
		Enums.level_layout[level_num][0].append(room_instance)
		Enums.level_layout[level_num][1][room_instance.name] = false
		#Enums.completed_rooms[room_instance.name] = false  # Mark incomplete

	# Connect rooms (example: simple linear layout)
	for i in range(num_rooms - 1):
		var current_room = Enums.level_layout[level_num][0][i]
		var next_room = Enums.level_layout[level_num][0][i + 1]
		current_room.connect_rooms(next_room)

func enter_room(index: int):
	var room = Enums.level_layout[level_num][0][index]
	get_tree().set_current_scene(room)
