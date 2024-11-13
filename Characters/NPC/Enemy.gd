extends CharacterBody2D

@export var stats : BaseStats

var player_behaviour = false
var player = null

@onready var game = get_tree().get_root().get_node("GameTest")
@onready var projectile = load("res://Game/Projectile.tscn")

func load_stats(character_stats: BaseStats) -> void:
	stats = character_stats.duplicate() as BaseStats
	stats.max_movement_speed = 100

func _ready() :
	load_stats(stats)
	
func behave(delta: float) -> void:
	if player_behaviour:
		velocity += (player.position - position)
		velocity.normalized()
		velocity *= (stats.max_movement_speed * delta)
		velocity = velocity.limit_length(stats.max_movement_speed)

func _physics_process(delta: float) -> void:
	behave(delta)
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")) :
		player = body
		print("Player detected")
		player_behaviour = true
	if (body.is_in_group("friendly_projectiles")) :
		print("Player projectile detected")
