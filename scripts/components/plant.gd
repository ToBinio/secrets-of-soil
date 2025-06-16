extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea
@export var grid_blocker: GridBlocker

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	plant.size = grid_blocker.size
	
func _on_click():
	print("harvest " + plant.name)
	Inventory.plants[plant] += 1;
	queue_free()
