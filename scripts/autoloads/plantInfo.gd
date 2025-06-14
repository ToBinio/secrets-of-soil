extends Node

signal on_plant_show(plant: Plant)

func show_plant(plant: Plant):
	on_plant_show.emit(plant)
