extends Node2D

class_name spawn

@export var max_spawns: int = 3  # Maximum entities to spawn

func spawn_entities(parent:Node, enemy):
	var enemies = []
	var spawn_points = get_children()
	for i in range(min(max_spawns, spawn_points.size())):
		var spawn_point = spawn_points[i]
		if spawn_point is Marker2D:  # Ensure it's a Marker2D
			var entity_instance = enemy.instantiate()
			entity_instance.position = spawn_point.global_position
			parent.add_child(entity_instance)
			enemies.append(entity_instance)
	return enemies
