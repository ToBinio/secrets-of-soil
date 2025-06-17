extends TextureRect


func _process(_delta: float) -> void:
	var game_manager = GameManager.instant(self)
	texture = game_manager.current_weather().icon
