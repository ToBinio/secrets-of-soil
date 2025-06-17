extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	
func _on_click():
	Inventory.plants[plant].harvested += 1
	GameManager.instant(self).stats.plants_harvested += 1
	queue_free()
