extends Control
"res://Game/Scripts/dungeon.gd"
@onready var dungeon = $"../"

func _on_resume_pressed() -> void:
	print("Reference:", dungeon)
	dungeon._on_exit_pressed()


func _on_quit_pressed() -> void:
	get_tree().quit()
