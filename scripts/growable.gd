extends Node

func _ready() -> void:
	Global.on_next_day.connect(_on_next_day)

func _on_next_day():
	print("nextDay!")
