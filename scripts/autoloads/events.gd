extends Node
 
signal on_plant_show(plant: PlantResource)
signal on_next_day(plant: PlantResource)

signal on_new_knowledge

var selected_plant: PlantResource

func show_plant(plant: PlantResource):
	on_plant_show.emit(plant)

func next_day():
	on_next_day.emit()

func new_knowledge():
	on_new_knowledge.emit()
