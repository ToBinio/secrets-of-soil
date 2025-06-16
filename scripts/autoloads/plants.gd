extends Node

@export var plants: Dictionary[PlantResource, PackedScene] = {}
@export var plants_previews: Dictionary[PlantResource, PackedScene] = {}

func all_plants() -> Array[PlantResource]:
	return plants.keys()

func get_scene_for_plant(plant: PlantResource) -> PackedScene:
	return plants[plant]
	
func get_preview_for_plant(plant: PlantResource) -> PackedScene:
	return plants_previews[plant]
