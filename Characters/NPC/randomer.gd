extends CharacterBody2D

@export var stats : BaseStats

@onready var ray_cast = $RayCast2D
@onready var timer = $waiting
@onready var duration = $moving_duration

@onready var projectile = load("res://Game/Projectile.tscn")
@onready var game = get_tree().get_root().get_node("GameTest")

var player = null
var player_behaviour = false
var move = false
var counted = false

func load_stats(character_stats: BaseStats) -> void:
	stats = character_stats.duplicate() as BaseStats
	stats.attack_range = 400.0
	stats.atack_speed = 2
	stats.damage = 1
	stats.max_movement_speed = 400

func _ready() -> void:
	randomize()
	load_stats(stats)
	player = get_parent().find_child("Player")
	print("This is player:", player)
	$AnimatedSprite2D.play("default")
	timer.start(stats.atack_speed)
		
func _physics_process(delta: float) -> void:
	#print("Timer:", timer.time_left)
	ray_cast.target_position = to_local(player.position)
	behave(delta)
	move_and_slide()

func behave(delta: float) -> void:
	if player_behaviour and move:
		if !counted :
			velocity += (player.position - position)
			velocity.normalized()
			print("Velocity player:", velocity)
			velocity *= (stats.max_movement_speed * delta)
			velocity = velocity.limit_length(stats.max_movement_speed)
			counted = true
	elif !player_behaviour and move:
		if !counted :
			velocity = get_random_unit_vector_2d()
			velocity.normalized()
			print("Velocity with no player:", velocity)
			velocity *= (stats.max_movement_speed)
			velocity = velocity.limit_length(stats.max_movement_speed)
			counted = true
	else :
		velocity = Vector2(0,0)
		
func get_random_unit_vector_2d() -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle))
	
func _process_collision():
	var distance_to_player = global_position.distance_to(player.global_position)
	counted = false
	
	if ray_cast.get_collider() == player and (distance_to_player < stats.attack_range):
		print("Spider can move to player")	
		player_behaviour = true
		duration.start(0.7)
	elif (ray_cast.get_collider() != player or (distance_to_player > stats.attack_range)):
		print("Spider cant move to player")
		player_behaviour = false
		duration.start(0.7)
	
	move = true

func _on_waiting_timeout() -> void:
	print("waiting is over")
	_process_collision()
	
func _on_moving_duration_timeout() -> void:
	move = false
	timer.start(stats.atack_speed)
