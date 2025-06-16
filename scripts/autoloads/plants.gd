extends Node

@export var plants: Dictionary[PlantResource, PackedScene] = {}

func all_plants() -> Array[PlantResource]:
	return plants.keys()

func get_scene_for_plant(plant: PlantResource) -> PackedScene:
	return plants[plant]
