extends Control

@export var plant_container: PackedScene

@onready var plant_box: GridContainer = $Background/GridContainer;

func _ready() -> void:
	for plant in Plants.all_plants():
		var container = plant_container.instantiate()
		container.plant = plant
		
		plant_box.add_child(container)
		
