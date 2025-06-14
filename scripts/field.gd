extends Node3D

@export var plant: Plant
@export var scene: PackedScene

@export var max_water: float

var _water: float;

func _ready() -> void:
	_water = max_water

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		if(_water - plant.water_consumption < 0):
			return
			
		_water -= plant.water_consumption;
		
		var flower_instance = scene.instantiate()
		add_child(flower_instance)
		
		flower_instance.global_position = event_position
