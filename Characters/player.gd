extends CharacterBody2D

class_name Player

@export var ACCELERATION = 1000
@export var FRICTION = 950
@export var PROJECTILE_CURVE = 0.3

@export var stats : Resource

@onready var axis = Vector2.ZERO
@onready var lookingDir = Vector2(0,1)
@onready var attackSpeed = $AttackSpeed
@onready var game = get_tree().get_root().get_node("Dungeon")
@onready var projectile = load("res://Game/Scenes/Projectile.tscn")

@export var inventory = []

func load_stats() -> void:
	var defaultStats = load("res://Characters/PlayerStats.tres")
	stats = defaultStats.duplicate(true)

func _ready() :
	load_stats()
		
func _physics_process(delta: float) -> void:
	_move(delta)

func _get_looking_dir() :
	if Input.is_action_pressed("ui_left") :
		lookingDir = Vector2(-1,0) + axis * PROJECTILE_CURVE
		_shoot()
	elif Input.is_action_pressed("ui_right") :
		lookingDir = Vector2(1,0) + axis * PROJECTILE_CURVE
		_shoot()
	elif Input.is_action_pressed("ui_up") :
		lookingDir = Vector2(0,-1) + axis * PROJECTILE_CURVE
		_shoot()
	elif Input.is_action_pressed("ui_down") :
		lookingDir = Vector2(0,1) + axis * PROJECTILE_CURVE
		_shoot()
	
	
func _get_input_axis() :
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func _move(delta) :
	axis = _get_input_axis()

	if axis == Vector2.ZERO:
		_apply_friction(FRICTION * delta)
	else:
		_apply_movement(axis * ACCELERATION * delta)
	_get_looking_dir()
	move_and_slide()

func _apply_friction(amount) :
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func _apply_movement(acceleration) :
	velocity += acceleration
	velocity = velocity.limit_length(stats.max_movement_speed)
		
func _shoot() :
	if attackSpeed.is_stopped():
		var instance = projectile.instantiate()
		instance.is_player_projectile = true
		instance.dir = lookingDir
		instance.spawnPos = global_position
		instance.spawnRot = rotation
		instance.zdex = z_index - 1
		instance.damage = stats.damage
		instance.speed = stats.projectile_speed
		instance.range = stats.attack_range
		game.add_child.call_deferred(instance)
		attackSpeed.start(stats.atack_speed)

func add_to_inventory(item):
	if item:  # Ensure item is valid
		inventory.append(item)
		get_parent().get_child(3).get_child(0).add_item(item.item_name)
		print("Picked up:", item.item_name)
		return true
	return false

func stat_change(item, data):
	if item != null:
		stats.max_health -= item.data.health
		stats.damage -= item.data.damage
		stats.atack_speed -= item.data.atack_speed
		stats.attack_range -=item.data.range
		stats.max_movement_speed -= item.data.movement_speed
		stats.luck -= item.data.luck
		stats.projectile_speed -= item.data.projectile_speed
		
	if data != null:
		stats.max_health += data.data.health
		stats.damage += data.data.damage
		stats.atack_speed += data.data.atack_speed
		stats.attack_range += data.data.range
		stats.max_movement_speed += data.data.movement_speed
		stats.luck += data.data.luck
		stats.projectile_speed += data.data.projectile_speed
