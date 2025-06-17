extends Label

func _process(_delta: float) -> void:
	var game_manager = GameManager.instant(self)
	text = "Day " + str(game_manager.stats.days_survived + 1)
