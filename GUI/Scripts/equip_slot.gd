extends PanelContainer
class_name EquipSlot

@export var dataType: Enums.ItemDataType
@export var itemType: Enums.ItemType

func init(t: Enums.ItemDataType, t2: Enums.ItemType, cms:Vector2) -> void:
	dataType = t
	itemType = t2
	custom_minimum_size = cms
		
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if dataType == Enums.ItemDataType.MAIN && itemType == data.data.item_type:
			if get_child_count() == 0:
				return true
			else:
				if dataType == data.get_parent().dataType:
					return true
				return get_child(0).data.data_type == data.data.data_type
		else:
			return data.data.data_type == dataType
	return false
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
		get_parent().get_parent().get_parent().get_parent().get_parent().get_child(0).stat_change(item, data)
	else:
		get_parent().get_parent().get_parent().get_parent().get_parent().get_child(0).stat_change(null, data)
	data.reparent(self)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 2) and (event.button_mask == 0):
			if get_child_count() > 0:
				if (get_child(0).data.dataType == Enums.ItemDataType.MISC):
					get_child(0).data.count -= 1
					get_child(0).get_child(0).text = str(get_child(0).data.count)
					if get_child(0).data.count <= 0:
						get_child(0).queue_free()
