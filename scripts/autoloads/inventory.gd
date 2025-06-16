extends Node

class Data:
	var harvested: int = 0
	var seeds: int = 0
	var max_seeds: int = 0

var plants: Dictionary[PlantResource, Data]

func _ready() -> void:
	for plant in Plants.all_plants():
		plants[plant] = Data.new()
