extends Control

@onready var video_player = $VideoStreamPlayer
@export var next_scene_path: String = "res://GUI/MainMenu/MainMenu.tscn"

func _ready():
	video_player.play()
	video_player.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file(next_scene_path)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		video_player.stop()
		get_tree().change_scene_to_file(next_scene_path)
