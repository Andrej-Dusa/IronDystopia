extends Node
class_name Door

@export var is_locked = true
var direction: String = ""
var connected_room_pos: Vector2 = Vector2.ZERO

@onready var static_body = $StaticBody2D
@onready var animation_player = $AnimatedSprite2D

func _ready():
	update_door_state()

func update_door_state():
	if is_locked:
		static_body.collision_layer = 2
		static_body.collision_mask = 2
		animation_player.play("idle_barier")
	else:
		static_body.collision_layer = 0
		static_body.collision_mask = 0
		animation_player.play("turned_off")

func unlock():
	is_locked = false
	animation_player.play("open_barier")
	update_door_state()

#func _on_area_2d_body_entered(body: Node2D):
	#if body.name == "player" and !is_locked:
		#get_parent().emit_signal("door_entered", connected_room_pos)
