extends Node

signal on_plant_show(plant: PlantResource)
signal on_next_day(plant: PlantResource)

@export var plants: Dictionary[PlantResource, PackedScene] = {}
var selected_plant: PlantResource

func show_plant(plant: PlantResource):
	on_plant_show.emit(plant)

func next_day():
	on_next_day.emit()

func all_plants() -> Array[PlantResource]:
	return plants.keys()

func get_scene_for_plant(plant: PlantResource) -> PackedScene:
	return plants[plant]
