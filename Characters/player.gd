extends CharacterBody2D

@export var ACCELERATION = 1000
@export var FRICTION = 950
@export var ATTACKSPEED = 0.5
@export var PROJECTILE_CURVE = 0.3

@onready var stats = load("res://Characters/PlayerStats.tres")

@onready var current_health: int = stats.max_health

@onready var axis = Vector2.ZERO
@onready var lookingDir = Vector2(0,1)
@onready var attackSpeed = $AttackSpeed
@onready var game = get_tree().get_root().get_node("GameTest")
@onready var projectile = load("res://Game/Projectile.tscn")

func load_stats(character_stats: BaseStats) -> void:
	stats = character_stats

func _ready() :
	_shoot()
	
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
	print(lookingDir)
	move_and_slide()

func _apply_friction(amount) :
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func _apply_movement(acceleration) :
	velocity += acceleration
	velocity = velocity.limit_length(stats.max_speed)
		
func _shoot() :
	if attackSpeed.is_stopped():
		var instance = projectile.instantiate()
		instance.dir = lookingDir
		instance.spawnPos = global_position
		instance.spawnRot = rotation
		instance.zdex = z_index - 1
		game.add_child.call_deferred(instance)
		attackSpeed.start(ATTACKSPEED)
