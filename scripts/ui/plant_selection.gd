extends Button

var plant: PlantResource

@onready var label: Label = $Label

func _ready() -> void:
	label.text = plant.name

func _on_pressed() -> void:
	Global.selected_plant = plant
