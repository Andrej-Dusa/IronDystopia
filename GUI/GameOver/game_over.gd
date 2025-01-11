extends CanvasLayer

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Scenes/dungeon.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
