extends Area3D

@export var plant: Plant

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		Global.show_plant(plant)
