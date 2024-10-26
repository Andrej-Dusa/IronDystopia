extends CharacterBody2D

@export var MAX_SPEED = 200
@export var ACCELERATION = 1000
@export var FRICTION = 950

@onready var axis = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_move(delta)

	
func _get_input_axis() :
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func _move(delta) :
	axis = _get_input_axis()

	if axis == Vector2.ZERO:
		_apply_friction(FRICTION * delta)
	else:
		_apply_movement(axis * ACCELERATION * delta)
	move_and_slide()

func _apply_friction(amount) :
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func _apply_movement(acceleration) :
	velocity += acceleration
	velocity = velocity.limit_length(MAX_SPEED)
		
