extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/HSlider.value = AudioServer.get_bus_volume_db(0) * 5
	$MarginContainer/VBoxContainer/Mute.button_pressed = AudioServer.is_bus_mute(0)
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	$MarginContainer/VBoxContainer/Fullscreen.button_pressed = is_fullscreen
	$MarginContainer/VBoxContainer/Resolutions.select(Enums.resolution)
	$MarginContainer/VBoxContainer/Difficulty.select(Enums.difficulty - 1)

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value * 0.2)


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/MainMenu/MainMenu.tscn")


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			Enums.resolution = 0
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			Enums.resolution = 1
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			Enums.resolution = 2
		3:
			DisplayServer.window_set_size(Vector2i(1024, 576))
			Enums.resolution = 3


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_difficulty_item_selected(index: int) -> void:
	match index:
		0:
			Enums.difficulty = 1
		1:
			Enums.difficulty = 2
		2:
			Enums.difficulty = 3
