extends Node2D

#@onready var open_menu = preload("res://Menus/MainMenu.tscn") as PackedScene

var items = {
	"cloak": preload("res://Items/Resources/item1.tres")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") :
		_on_exit_pressed()
	elif Input.is_action_just_pressed("inventory"):
		var instance = $GUI
		if instance:
			if instance.is_visible():
				instance.hide() 
			else:
				instance.show()

func _on_exit_pressed():
	get_tree().quit()
