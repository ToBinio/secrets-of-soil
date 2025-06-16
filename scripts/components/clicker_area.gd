extends Area3D
class_name ClickerArea

signal on_click

@export var growable: Growable

func _ready() -> void:
	if(growable):
		input_ray_pickable = false
		growable.on_fully_grown.connect(func(): input_ray_pickable = true)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		on_click.emit()
