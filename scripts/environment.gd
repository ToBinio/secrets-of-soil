extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Events.on_next_day.connect(_on_nect_day)
	
func _on_nect_day():
	animation_player.play("DayNightCycle")
	
