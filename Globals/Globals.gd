extends Node

enum ItemDataType {MISC, MAIN}
enum ItemType {WEAPON, ARMOR, HELMET, TRINKET, BOOTS, CONSUMABLE}
enum Specials {INVISIBILITY, SPEEDUP, REGEN, LIVESTEAL, DODGE, SELF_DOT, DOT}
enum Rarity {NORMAL, RARE, LEGENDARY}
@export var x: Rarity

@export var prefixes = ["Simple", "Boring", "Gloriuos",
 "Nano", "Unimaginable", "Pretty", "Rusty", "Shiny", "Supreme", "Cute"]

@export var sufixes = ["Laziness", "Courage", "Smoothness", "Craziness",
"Highness", "Supremacy", "Edginess", "Insensibility", "Huh?", "Cuteness"]

@export var rarity = { 	"NORMAL": [70, 1, 2],
"RARE": [25, 3, 4],
"LEGENDARY": [5, 6, 10] }

@export var spawn_dist = { "weapon": 10,
"armor": 10,
"helmet": 10,
"boots": 10,
"trinket": 10,
"consumable": 50 }

@export var items = {}
