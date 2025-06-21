extends Area3D
class_name ClickerArea

signal on_click

@export var growable: Growable
@export var hover_label: Node3D

const PLANT_STATS = preload("res://scripts/resources/knowledge/plant_stats.tres")

var fully_grown = false

func _ready() -> void:
	if(growable):
		growable.on_fully_grown.connect(func(): fully_grown = true)
	
	if hover_label:
		hover_label.hide()

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if !fully_grown:
		return
		
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		on_click.emit()

func _on_mouse_entered() -> void:
	if hover_label:
		Knowledge.try_add_general_knowledge(PLANT_STATS)
		hover_label.show()

func _on_mouse_exited() -> void:
	if hover_label:
		hover_label.hide()
