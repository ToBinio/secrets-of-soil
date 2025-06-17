extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Panel/Label

@onready var water_progress_bar: ProgressBar = $Panel/ScrollContainer/VBoxContainer/Water/ProgressBar
@onready var food_label: Label = $Panel/ScrollContainer/VBoxContainer/Food/Value

var _open: bool = false;

func _ready() -> void:
	Events.on_plant_show.connect(_on_plant_show)

func _on_plant_show(plant: PlantResource):
	label.text = plant.name
	water_progress_bar.value = plant.preferred_water
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
