extends PanelContainer
class_name InventorySlot

@export var dataType: Enums.ItemDataType

func init(t: Enums.ItemDataType, cms:Vector2) -> void:
	dataType = t
	custom_minimum_size = cms
		
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if dataType == Enums.ItemDataType.MAIN:
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
	var child = Enums.player_instance
	var dataParent = data.get_parent()
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		if dataParent is EquipSlot:
			child.stat_change(data, item)
		item.reparent(data.get_parent())
	elif dataParent is EquipSlot:
		child.stat_change(data, null)
	data.reparent(self)
	
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 2) and (event.button_mask == 0):
			if get_child_count() > 0:
				if (get_child(0).data.data_type == Enums.ItemDataType.MISC):
					get_child(0).data.count -= 1
					Enums.player_instance.consume(get_child(0).data)
					get_child(0).get_child(0).text = str(get_child(0).data.count)
					if get_child(0).data.count <= 0:
						get_child(0).queue_free()
				elif get_child(0).data.data_type == Enums.ItemDataType.MAIN:
					get_child(0).queue_free()
