extends Label

func _process(_delta: float) -> void:
	var game_manager = GameManager.instant(self)
	text = str(game_manager.current_food_requirements)
