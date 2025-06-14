extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Panel/Label

var _open: bool = false;

func _ready() -> void:
	Global.on_plant_show.connect(_on_plant_show)

func _on_plant_show(plant: PlantResource):
	label.text = plant.name
	
	if(_open):
		return
	
	animation_player.play("slideIn")
	_open = true

func _on_close_button_down() -> void:
	if(!_open):
		return
	
	animation_player.play("slideOut")
	_open = false
