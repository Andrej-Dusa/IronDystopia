extends Node2D

signal door_entered(pos: Vector2)
signal room_exited(prev_pos: Vector2)
signal elevator_entered(level)

@export var room_scenes: Array = [
	preload("res://Game/Scenes/room_t_1.tscn"),
	preload("res://Game/Scenes/room_t_2.tscn"),
	preload("res://Game/Scenes/room_t_3.tscn"),
	preload("res://Game/Scenes/room_t_4.tscn"),
	preload("res://Game/Scenes/room_t_5.tscn")
]
@export var num_rooms: int = 1
@export var level_num: int = 1

var current_room: Node = null
var entry_direction: String = ""
var current_room_position: Vector2 = Vector2.ZERO
var directions := {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

func _ready():
	add_to_group("Level")
	self.connect("elevator_entered", Callable(self, "_on_move_to_next_level"))

func generate_floor(level):
	level_num = level
	Enums.level_layout[level_num] = {}
	var pos = Vector2(0, 0)
	Enums.level_layout[level_num][pos] = {
		"scene_path": room_scenes.pick_random().resource_path,
		"cleared": false,
		"connections": {}
	}
	for i in range(num_rooms - 1):
		var possible = directions.keys().filter(func(d): return !Enums.level_layout[level_num].has(pos + directions[d]))
		if possible.is_empty():
			break
		var dir = possible.pick_random()
		var new_pos = pos + directions[dir]
		var back = get_reverse_direction(dir)
		Enums.level_layout[level_num][new_pos] = {
			"scene_path": room_scenes.pick_random().resource_path,
			"cleared": false,
			"connections": {back: pos}
		}
		Enums.level_layout[level_num][pos]["connections"][dir] = new_pos
		pos = new_pos
	var last_pos = pos  # already stores the last room's position
	Enums.level_layout[level_num][last_pos]["has_elevator"] = true
	load_room_at(Vector2(0, 0))

func get_reverse_direction(dir):
	match dir:
		"up": return "down"
		"down": return "up"
		"left": return "right"
		"right": return "left"
		_: return ""

func load_room_at(pos: Vector2):
	if current_room:
		emit_signal("room_exited", current_room_position)
		remove_child(current_room)
		current_room.queue_free()
		current_room = null

	var data = Enums.level_layout[level_num][pos]
	var room = load(data.scene_path).instantiate()
	room.room_position = pos
	room.level_index = level_num
	room.is_cleared = data.cleared
	room.connections = data.connections

	if not room.has_signal("door_entered"):
		room.add_user_signal("door_entered", ["pos"])

	add_child(room)
	current_room = room
	current_room_position = pos
	room.populate_room()

	room.connect("door_entered", Callable(self, "_on_door_entered"))

	if Enums.player_instance:
		if Enums.player_instance.get_parent():
			Enums.player_instance.get_parent().remove_child(Enums.player_instance)
		room.add_child(Enums.player_instance)
		var spawn_node = room.get_node_or_null("PlayerSpawn_" + entry_direction)
		if not spawn_node:
			spawn_node = room.get_node_or_null("PlayerSpawn_left")  # fallback
		if spawn_node:
			Enums.player_instance.global_position = spawn_node.global_position


func _on_door_entered(target_room_pos: Vector2):
	entry_direction = get_reverse_direction(find_direction_between(current_room_position, target_room_pos))
	print(entry_direction)
	load_room_at(target_room_pos)

func find_direction_between(from: Vector2, to: Vector2) -> String:
	for dir in directions:
		if from + directions[dir] == to:
			return dir
	return ""
	
func _on_move_to_next_level(level):
	generate_floor(level)
