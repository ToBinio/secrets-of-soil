extends Node

class Data:
	var harvested: int = 0
	var seeds: int = 0
	var max_seeds: int = 0

var plants: Dictionary[PlantResource, Data]

func discoverd_plants() -> Array[PlantResource]:
	var discovered: Array[PlantResource] = []
	for plant in plants.keys():
		var data: Data = plants[plant]
		if data.max_seeds != 0:
			discovered.append(plant)
	return discovered

func undiscoverd_plants() -> Array[PlantResource]:
	var undiscovered: Array[PlantResource] = []
	for plant in plants.keys():
		var data: Data = plants[plant]
		if data.max_seeds == 0:
			undiscovered.append(plant)
	return undiscovered
	
func _ready() -> void:
	for plant in Plants.all_plants():
		plants[plant] = Data.new()
