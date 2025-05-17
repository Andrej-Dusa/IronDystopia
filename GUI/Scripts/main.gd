extends Control

@export var inventorySize = 42
@onready var grid = get_node("InventoryGrid")

func _ready() -> void:
	for i in range(inventorySize):
		var slot := InventorySlot.new()
		slot.init(Enums.ItemDataType.MAIN, Vector2(64, 64))
		grid.add_child(slot)


func add_item(item_name: String) -> void:
	var item := InventoryItem.new()
	item.init(Enums.items[item_name])
	if item.data.stackable:
		for i in inventorySize:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data.item_name == item.data.item_name:
					grid.get_child(i).get_child(0).data.count += 1
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					grid.get_child(i).get_child(0).get_child(0).add_theme_color_override("font_color", Color.CRIMSON)
					break
			else:
				grid.get_child(i).add_child(item)
				break
				
	else:
		for i in inventorySize:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
