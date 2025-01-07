extends Node2D

class_name PlayerSpawn

func spawn_entities(parent:Node):
	print("Children of PlayerSpawn:", get_children())
	var spawn_point = get_node_or_null("PlayerMark")
	if spawn_point == null:
		print("Error: Marker2D not found in PlayerSpawn! Node path may be incorrect.")
		return
	else:
		print("Marker2D found:", spawn_point.name, "at position:", spawn_point.global_position)
		var entity_instance = Enums.player_instance
		entity_instance.position = spawn_point.global_position
		if entity_instance.get_parent() != null:
			entity_instance.reparent(parent)
		else:
			parent.add_child(entity_instance)
