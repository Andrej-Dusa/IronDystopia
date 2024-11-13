extends CharacterBody2D

@export var SPEED = 200

var damage = 10
var dir : Vector2
var spawnPos : Vector2
var spawnRot : float
var zdex : int

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	 
func _physics_process(delta: float) :
	velocity = dir * SPEED
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) :
	print("HIT!!!")
	queue_free()


func _on_life_timeout() -> void:
	queue_free()
