extends Node

signal on_plant_show(plant: Plant)
signal on_next_day(plant: Plant)

func show_plant(plant: Plant):
	on_plant_show.emit(plant)

func next_day():
	on_next_day.emit()
