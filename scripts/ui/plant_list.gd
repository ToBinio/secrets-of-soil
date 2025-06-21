extends Control

@export var plant_container: PackedScene

@onready var plant_box: GridContainer = $Background/GridContainer;

var rendered_plants: Array[PlantResource] = []

func _ready() -> void:
	for plant in Inventory.plants_with_seeds():
		add_plant(plant)

func _process(_delta: float) -> void:
	for plant in Inventory.plants_with_seeds():
		if(rendered_plants.has(plant)):
			continue
			
		add_plant(plant)

func add_plant(plant: PlantResource):
	rendered_plants.push_back(plant)
	
	var container = plant_container.instantiate()
	container.plant = plant
	
	plant_box.add_child(container)
