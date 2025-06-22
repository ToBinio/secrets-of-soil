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
	
func plants_with_seeds() -> Array[PlantResource]:
	var list: Array[PlantResource] = []
	
	for plant in plants.keys():
		if plants[plant].max_seeds == 0:
			continue
		
		list.push_back(plant)
	
	return list

func undiscoverd_plants() -> Array[PlantResource]:
	var undiscovered: Array[PlantResource] = []
	for plant in plants.keys():
		var data: Data = plants[plant]
		if data.max_seeds == 0:
			undiscovered.append(plant)
	return undiscovered

func reset():
	plants = {}
	for plant in Plants.all_plants():
		plants[plant] = Data.new()

func _ready() -> void:
	reset()
