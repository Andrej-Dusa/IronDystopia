extends Node

class_name Door

@export var is_locked = true
@onready var static_body = $StaticBody2D# Reference to the StaticBody2D
@onready var animation_player = $AnimatedSprite2D

func _ready():
	update_door_state()
	
	
func update_door_state() -> void:
	if is_locked:
		static_body.collision_layer = 2 # Enable collisions
		static_body.collision_mask = 2
		animation_player.play("idle_barier")
	else:
		static_body.collision_layer = 0 # Disable collisions
		static_body.collision_mask = 0
		animation_player.play("turned_off")

func unlock():
	is_locked = false
	animation_player.play("open_barier")
	update_door_state()
	print("Door unlocked:", name)

func _on_body_entered(body):
	if body.is_in_group("Player") and is_locked:
		print("Door is locked!")
	elif body.is_in_group("Player"):
		print("Player entered unlocked door!")
		
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" and !is_locked:
		get_parent().call_deferred("next_room") # Replace with function body.
