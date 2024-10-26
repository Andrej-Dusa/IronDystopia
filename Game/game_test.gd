extends Node2D

#@onready var open_menu = preload("res://Menus/MainMenu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") :
		_on_exit_pressed()

func _on_exit_pressed():
	get_tree().quit()
