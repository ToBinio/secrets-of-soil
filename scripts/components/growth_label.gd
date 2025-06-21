extends Node3D
class_name GrowthLabel

@export var growable: Growable

@export var fully_grown: Texture2D
@export var partialy_grown: Texture2D
@export var slightly_grown: Texture2D
@export var not_grown: Texture2D

@export var full_speed: Texture2D
@export var partialy_speed: Texture2D
@export var slightly_speed: Texture2D
@export var not_speed: Texture2D

@onready var growth_speed: Sprite3D = $GrowthSpeed
@onready var growth_state: Sprite3D = $GrowthState

func _process(_delta: float) -> void:
	var speed = growable.calc_growth_factor()
	
	growth_speed.texture = not_speed
	if(speed > 0.40):
		growth_speed.texture = slightly_speed
	if(speed > 0.70):
		growth_speed.texture = partialy_speed
	if(speed > 0.9):
		growth_speed.texture = full_speed
	
	growth_state.texture = not_grown
	if(growable.target_size > 0.5):
		growth_state.texture = slightly_grown
	if(growable.target_size > 0.75):
		growth_state.texture = partialy_grown
	if(growable.target_size >= 1.0):
		growth_state.texture = fully_grown
