extends Node3D
class_name Field

@export var scene: PackedScene
@export_range(0, 1) var water_level: float

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		var plant_instance = scene.instantiate() as Plant
		plant_instance.field = self
		add_child(plant_instance)
		
		plant_instance.global_position = event_position
