extends Control

@export var inventorySize = 24
@onready var grid = get_node("InventoryGrid")

func _ready() -> void:
	for i in inventorySize:
		var slot := InventorySlot.new()
		slot.init(Globals.ItemDataType.MAIN, Vector2(32, 32))
		grid.add_child(slot)
	add_item("cloak")

func add_item(item_name: String) -> void:
	var item := InventoryItem.new()
	item.init(GameTest.items[item_name])
	if item.data.stackable:
		pass
		for i in inventorySize:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data == item.data:
					grid.get_child(i).get_child(0).data.count += 1
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
			else:
				grid.get_child(i).add_child(item)
				break
				
	else:
		for i in inventorySize:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
