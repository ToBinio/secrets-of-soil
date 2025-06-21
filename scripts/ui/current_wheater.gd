extends TextureRect

@export var day_offset: int

func _process(_delta: float) -> void:
	var game_manager = GameManager.instant(self)
	var weather = game_manager.weather_at(day_offset)
	
	if not weather:
		texture = null
	else:
		texture = weather.icon
