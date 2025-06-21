extends Control

@export var click_sound: AudioStream;

func _on_pressed() -> void:
	if GameManager.instant(self).is_doing_day_night_cycle:
		return
		
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
	
	Events.next_day()
