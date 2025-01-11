extends Node2D

class_name ItemDrop

@export var item_name: String  # Name of the item
@export var item_data: Resource

func _ready() -> void:
	$ItemTexture.texture = item_data.item_texture  # Assuming your item data has an icon

func on_player_pickup(player):
	if player.add_to_inventory(item_data):  # Call player's inventory method
		queue_free()  # Remove the item from the map
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		on_player_pickup(body)
