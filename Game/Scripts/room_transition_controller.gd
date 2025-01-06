extends Node2D

func transition_to_room(index: String, level:int):
	if Enums.level_layout[level][0][index]:
		Enums.level_layout[level][0][index].populate_room()
		get_tree().set_current_scene(Enums.level_layout[level][0][index])
