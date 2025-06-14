extends Node3D

@export var flower: PackedScene

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		var flower_instance = flower.instantiate()
		add_child(flower_instance)
		flower_instance.global_position = event_position
		
