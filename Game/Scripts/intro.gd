extends Node2D

@onready var animation_player = $AnimatedSprite2D
@onready var dungeon_scene = preload("res://Game/Scenes/dungeon.tscn") as PackedScene

var cutscene_skipped = false

func _ready():
	var timer = $Timer
	timer.start(2)
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not cutscene_skipped:
		cutscene_skipped = true
		load_dungeon()

func load_dungeon():
	if dungeon_scene:
		print("Dungeon scene preloaded:", dungeon_scene)
		get_tree().change_scene_to_packed(dungeon_scene)
		print("Transitioned to dungeon scene.")
	else:
		print("Dungeon scene not preloaded.")
	#get_tree().change_scene_to_packed(dungeon_scene)

func _on_animated_sprite_2d_animation_finished() -> void:
	if not cutscene_skipped:
		cutscene_skipped = true
		load_dungeon()


func _on_ready() -> void:
	animation_player.play("intro")
