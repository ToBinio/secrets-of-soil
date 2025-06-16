extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea
@export var grid_blocker: GridBlocker

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	grid_blocker.size = plant.size
	
func _on_click():
	print("harvest " + plant.name)
	Inventory.plants[plant].harvested += 1;
	queue_free()
