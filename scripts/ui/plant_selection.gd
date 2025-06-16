extends Button

var plant: PlantResource

@onready var name_label: Label = $Name

func _ready() -> void:
	name_label.text = plant.name

func _on_pressed() -> void:
	Global.selected_plant = plant


func _on_info_button_pressed() -> void:
	Global.show_plant(plant)
