extends Node2D

#@onready var open_menu = preload("res://Menus/MainMenu.tscn") as PackedScene
@onready var level_container = $Level
@onready var camera = $Camera2D

var current_level: Node = null

var item_drop_scene = preload("res://Items/ItemDrop.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Dungeon scene ready!")
	if not has_node("GUI"):
		print("Error: Node 'GUI' not found in the scene tree.")
	else:
		var node = $GUI
		node.hide()
	if has_node("Level"):
		print("Level node found")
		initialize_player()
		level_container.generate_floor(1)
	else:
		print("Level node not found")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var instance = $GUI if has_node("GUI") else null
	if not instance:
		return  # Safely exit if 'GUI' is missing
	if Input.is_action_just_pressed("ui_cancel"):
		_on_exit_pressed()
	elif Input.is_action_just_pressed("inventory"):
		if instance.is_visible():
			instance.hide()
		else:
			instance.show()
	elif Input.is_action_just_pressed("Spawn"):
		spawn_item(Vector2(100, 100))

func _on_exit_pressed():
	get_tree().quit()

func spawn_item(position):
	var itemToSpawn = chooseItemToSpawn()
	
	var stringFormat = "res://Items/Resources/%s.tres"
	var string = stringFormat % itemToSpawn
	var res = load(string)
			
	var itemName = buildItemName(itemToSpawn)
	var item_instance = item_drop_scene.instantiate()
	item_instance.position = position
	item_instance.item_name = itemName
	item_instance.item_data = rarityGen(res, itemToSpawn)
	item_instance.item_data.item_name = itemName
	Enums.items[itemName] = item_instance.item_data
	self.add_child.call_deferred(item_instance)
	
func chooseItemToSpawn():
	var itemToSpawn
	var keys = Enums.spawn_dist.keys()
	randomize()
	var roll = randi_range(0,100)
	for i in keys:
		if roll <= Enums.spawn_dist[i]:
			itemToSpawn = i
			break
		else:
			roll -= Enums.spawn_dist[i]
	return itemToSpawn

func buildItemName(item):
	var prefix
	var sufix
	randomize()
	prefix = Enums.prefixes[randi() % Enums.prefixes.size()]
	randomize()
	sufix = Enums.sufixes[randi() % Enums.sufixes.size()]
	var itemNameFormat = "%s %s of %s"
	var itemName = itemNameFormat % [prefix, item, sufix]
	return itemName

func rarityGen(resource, itemToSpawn):
	var rarity
	var res = resource.duplicate(true)
	if itemToSpawn != "consumable":
		res.data_type = Enums.ItemDataType.MAIN
	var keys = Enums.rarity.keys()
	var rarityModMin
	var rarityModMax
	randomize()
	var roll = randi_range(0,100)
	for i in keys:
		if roll <= Enums.rarity[i][0]:
			rarity = i
			rarityModMin = Enums.rarity[i][1]
			rarityModMax = Enums.rarity[i][2]
			break
		else:
			roll -= Enums.rarity[i][0]
	randomize()
	var mod = randi_range(rarityModMin, rarityModMax)
	res.rarity = rarity
	for property in res.get_property_list():
		var name = property.name
		# Ensure the property is writable and numeric
		if res.has_method("set") and property.type in [TYPE_INT, TYPE_FLOAT]:
			var current_value = res.get(name)
			if name not in ["data_type", "item_type", "rarity"]:
				res.set(name, current_value * mod)
				res.emit_changed()
				print(current_value * mod)
				print("Updated value:", res.get(name))
			if current_value > 0:
				var stringFormat = "+%d %s\n"
				var string = stringFormat % [res.get(name), name]
				res.item_description += string
	var stringBuilder = "res://assets/Objects/1 Icons/%s%s.png"
	var string = stringBuilder % [itemToSpawn, str(rarity)]
	res.item_texture = load(string)
	res.item_description += "\n"
	res.item_description += str(rarity)
	return res
	
func initialize_player():
	if Enums.player_instance == null:
		Enums.player_instance = preload("res://Characters/Player.tscn").instantiate()
		Enums.player_instance.name = "player"
