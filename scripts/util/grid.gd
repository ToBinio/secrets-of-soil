extends Node

const cell_size = 0.5

func to_grid_cord(cord: Vector3) -> Vector3:
	var new_cord = cord.snapped(Vector3(cell_size,cell_size,cell_size))
	new_cord.y = cord.y
	return new_cord
