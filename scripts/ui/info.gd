extends Control
class_name PantInfoDisplay

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Panel/Label

@onready var food_label: Label = $Panel/ScrollContainer/VBoxContainer/Food/Value
@onready var water_display: Control = $Panel/ScrollContainer/VBoxContainer/Water/WaterDisplay

var _open: bool = false;

var plant: PlantResource

func _ready() -> void:
	Events.on_plant_show.connect(_on_plant_show)

func _on_plant_show(new_plant: PlantResource):
	plant = new_plant
	
	label.text = plant.name
	food_label.text = str(plant.food)
	
	if(_open):
		return
	
	animation_player.play("slideIn")
	_open = true

func _on_close_button_down() -> void:
	if(!_open):
		return
	
	animation_player.play("slideOut")
	_open = false
