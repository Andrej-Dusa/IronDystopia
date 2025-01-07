extends Node2D

@export var stats : BaseStats

@onready var ray_cast = $RayCast2D
@onready var timer = $Timer

@onready var projectile = load("res://Game/Scenes/Projectile.tscn")
@onready var game = get_tree().get_root().get_node("Dungeon")

var player

func load_stats(character_stats: BaseStats) -> void:
	stats = character_stats.duplicate() as BaseStats
	stats.atack_speed = 2
	stats.attack_range = 1.5
	stats.projectile_speed = 400
	stats.damage = 1

func _ready() -> void:
	load_stats(stats)
	player = Enums.player_instance
	$CharacterBody2D/AnimatedSprite2D.play("default")
	
func _physics_process(delta: float) -> void:
	_aim()
	_process_collision()
	
func _aim():
	ray_cast.target_position = to_local(player.position)
	
func _process_collision():
	var distance_to_player = global_position.distance_to(player.global_position)
	var projectile_distance = (stats.attack_range * stats.projectile_speed)
	var first_shot = true
	
	if ray_cast.get_collider() == player and timer.is_stopped() and (distance_to_player < projectile_distance):
		print("can shoot")
		if first_shot:
			timer.start(0.5)
			first_shot = false
		else:
			timer.start(stats.atack_speed)
	elif (ray_cast.get_collider() != player or (distance_to_player > projectile_distance)) and not timer.is_stopped():
		print("cant shoot")
		timer.stop()
		first_shot = true
		
func _on_timer_timeout():
	_shoot()
 
func _shoot():
	print("Shoooting")
	var instance = projectile.instantiate()
	instance.is_player_projectile = false
	instance.spawnPos = position
	instance.dir = (ray_cast.target_position).normalized()
	instance.zdex = z_index - 1
	instance.damage = stats.damage
	instance.speed = stats.projectile_speed
	instance.range = stats.attack_range
	game.add_child.call_deferred(instance)
	timer.start(stats.atack_speed)
