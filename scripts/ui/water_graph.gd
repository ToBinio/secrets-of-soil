extends Control
class_name WaterGraph

@onready var research_label: Label = $"../WaterGraphResearch";
var curve: Curve;

func _ready() -> void:
	pass

func _process(delta: float) -> void:
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
	
	print(draw)
	
	var width = size.x
	var height = size.y
	var points = []
	var resolution = 100

	for i in range(resolution + 1):
		var t = i / float(resolution)
		var x = t * width
		var y = (1.0 - curve.sample(t)) * height
		points.append(Vector2(x, y))
	
	draw_polyline(points, Color.BLUE, 2.0)
	
	draw_line(Vector2(0,0),Vector2(0,height),Color.BLACK, 2.0)
	draw_line(Vector2(0,height),Vector2(width,height),Color.BLACK, 2.0)
