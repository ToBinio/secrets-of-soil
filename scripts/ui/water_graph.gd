extends Control
class_name WaterGraph

@onready var research_label: Label = $"../WaterGraphResearch";
var curve: Curve;

@export var curve_color: Color
@export var axes_color: Color

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if curve:
		research_label.visible = false;
		visible = true;
	else:
		research_label.visible = true;
		visible = false;
	queue_redraw()

func _draw() -> void:
	if not curve:
		return
	
	var width = size.x
	var height = size.y
	var points = []
	var resolution = 100

	for i in range(resolution + 1):
		var t = i / float(resolution)
		var x = t * width
		var y = (1.0 - curve.sample(t)) * height
		points.append(Vector2(x, y))
	
	draw_polyline(points, curve_color, 2.0)
	
	draw_line(Vector2(0,0),Vector2(0,height),axes_color, 2.0)
	draw_line(Vector2(0,height),Vector2(width,height),axes_color, 2.0)
