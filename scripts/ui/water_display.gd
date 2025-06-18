extends Control

@export var info: PantInfoDisplay

func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	if not info.plant:
		return

	var width = size.x
	var height = size.y
	var points = []
	var resolution = 100

	for i in range(resolution + 1):
		var t = i / float(resolution)
		var x = t * width
		var y = (1.0 - info.plant.growth_effecency.sample(t)) * height
		points.append(Vector2(x, y))
	
	draw_polyline(points, Color.BLUE, 2.0)
