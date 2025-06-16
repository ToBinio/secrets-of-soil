extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea

var field: Field

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	
func _on_click():
	print("harvest " + plant.name)
	queue_free()
