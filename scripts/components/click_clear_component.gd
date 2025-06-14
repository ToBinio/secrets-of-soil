extends Area3D
class_name ClickClearComponent

@export var radius: float
@onready var shape: CollisionShape3D = $CollisionShape3D

func _ready():
	shape.shape.radius = radius
	pass

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		pass
