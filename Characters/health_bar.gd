extends TextureProgressBar

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()
	if player.has_signal("healthUpdated"):
		player.connect("healthUpdated", Callable(self, "update"))
		player.connect("initialHPUpdate", Callable(self, "update"))


func update():
	value = player.currentHealth * 100 / player.stats.max_health
