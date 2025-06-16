extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea
@export var grid_blocker: GridBlocker

@export var preview: bool

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	grid_blocker.size = plant.size
	
	if preview:
		grid_blocker.remove_from_group("GridBlocker")
	
func _on_click():
	print("harvest " + plant.name)
	Inventory.plants[plant] += 1;
	queue_free()
