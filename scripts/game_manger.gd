extends Node

@export var default_plants: Dictionary[PlantResource, int]

func _ready() -> void:
	for key in default_plants.keys():
		Inventory.plants[key].max_seeds = default_plants[key]
	
	_reset_inventory()
	
	Events.on_next_day.connect(_reset_inventory)
		
func _reset_inventory():
	for key in Inventory.plants.keys():
		Inventory.plants[key].seeds = Inventory.plants[key].max_seeds
