extends CharacterBody2D
@export var SPEED = 200

var damage = 10
var dir : Vector2
var spawnPos : Vector2
var spawnRot : float
var zdex : int 
var speed : int
var range : int
var is_player_projectile : bool

func _ready():
	print(is_player_projectile)
	var area2d = $Area2D
	if is_player_projectile:
		collision_layer = (1 << 4) #Layer(5)
		area2d.collision_layer = (1 << 4)
		area2d.collision_mask = (1 << 3)
		add_to_group("friendly_projectiles")
	else :
		area2d.collision_layer = (1 << 5)
		area2d.collision_mask = 1
		
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	
	var life = $Life
	life.start(range)	
	 
func _physics_process(delta: float) :
	velocity = dir * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) :
	print("HIT!!!")
	queue_free()


func _on_life_timeout() -> void:
	queue_free()
