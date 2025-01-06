extends CharacterBody2D

@export var stats : BaseStats

@onready var projectile = load("res://Game/Projectile.tscn")
@onready var game = get_tree().get_root().get_node("GameTest")

func load_stats(character_stats: BaseStats) -> void:
	stats = character_stats.duplicate() as BaseStats
	stats.attack_range = 400.0
	stats.atack_speed = 2
	stats.damage = 1
	stats.max_movement_speed = 400
	
func _ready() -> void:
	randomize()
	load_stats(stats)
	$AnimatedSprite2D.play("default")
	velocity = Vector2(get_random_outcome(), get_random_outcome()).normalized() * stats.max_movement_speed
		
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision :
		velocity = velocity.bounce(collision.get_normal())
	if velocity.x >= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func get_random_outcome() -> int:
	var outcomes = [-200, 200]
	return outcomes[randi() % outcomes.size()]

func get_damage():
	return stats.damage

func take_damage(amount):
	stats.max_health -= amount
	print("Enemy health is:", stats.max_health)
	if stats.max_health <= 0:
		die()

func die():
	randomize()
	var probability = randf()
	if probability > 0.3:
		game.spawn_item(position)
	queue_free()
