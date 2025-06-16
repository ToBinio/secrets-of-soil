extends Node

var plants: Dictionary[PlantResource, int]

func _ready() -> void:
	for plant in Plants.all_plants():
		plants[plant] = 0
