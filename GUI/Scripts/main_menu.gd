extends Control

@onready var intro_scene = preload("res://Game/Scenes/intro.tscn") as PackedScene
@onready var settings_scene = preload("res://GUI/MainMenu/Settings.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(intro_scene)


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(settings_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
