extends Control

func _on_pressed() -> void:
	if GameManager.instant(self).is_doing_day_night_cycle:
		return
	
	Events.next_day()
