extends Node
class_name Elevator

@export var is_locked = true

@onready var area = $Area2D
@onready var anim = $AnimatedSprite2D
@onready var static_body = $StaticBody2D

func _ready():
	update_state()
	

func update_state():
	if is_locked:
		static_body.collision_layer = 2
		static_body.collision_mask = 2
		anim.play("locked")
	else:
		static_body.collision_layer = 0
		static_body.collision_mask = 0
		area.body_entered.connect(_on_body_entered)
		anim.play("open")
	

func unlock():
	is_locked = false
	update_state()

func _on_body_entered(body: Node2D):
	if body.name == "player" and not is_locked:
		var level = get_parent().get_parent()
		if level:
			level.emit_signal("elevator_entered", level.level_num + 1)
