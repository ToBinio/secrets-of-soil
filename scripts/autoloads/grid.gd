extends Node

const cell_size = 0.5
const grid_size = 20

func to_grid_cord(cord: Vector3) -> Vector3:
	var new_cord = cord.snapped(Vector3(cell_size,cell_size,cell_size))
	new_cord.y = cord.y
	return new_cord

func get_water_percentage(grid_pos: Vector3) -> float:
	var wells = get_tree().get_nodes_in_group("Well") as Array[Node3D]
	var closest_distance = INF
	
	for well in wells:
		var well_pos = Grid.to_grid_cord(well.global_position)
		var distance = grid_pos.distance_to(well_pos)
		
		if(distance < closest_distance):
			closest_distance = distance
	
	var water_level = 1 - min(closest_distance, 10) / 10;
	return water_level

func is_valid_location(grid_pos: Vector3, node: Node) -> bool:
	var size = _get_size_from_node(node) * cell_size
	
	if(_is_outside(grid_pos, size)):
		return false
	
	return _get_collisions(grid_pos, size).is_empty()
	
func is_valid_location_ignore_plants(grid_pos: Vector3, node: Node):
	var size = _get_size_from_node(node) * cell_size
	
	if(_is_outside(grid_pos, size)):
		return false
	
	var collisions = _get_collisions(grid_pos, size)
	for collision in collisions:
		if !collision.is_in_group("Plant"):
			return false
	
	return collisions

func _get_size_from_node(node: Node) -> float:
	for child in node.get_children():
		if child is GridBlocker:
			return child.size
			
	printerr("is_valid_location called with node that does not have a size!")
	return 0

func _is_outside(grid_pos: Vector3, real_size: float) -> bool:
	var half = (real_size - Grid.cell_size) / 2
	var min_a = grid_pos - Vector3(half, 0, half)
	var max_a = grid_pos + Vector3(half, 0, half)
	
	#Check if outside grid bounds
	var min_grid = Vector3(-Grid.grid_size * Grid.cell_size, 0, -Grid.grid_size * Grid.cell_size)
	var max_grid = Vector3(Grid.grid_size * Grid.cell_size, 0, Grid.grid_size * Grid.cell_size)
	
	if min_a.x <= min_grid.x or max_a.x >= max_grid.x:
		return true
	if min_a.z <= min_grid.z or max_a.z >= max_grid.z:
		return true
	
	return false


func _get_collisions(grid_pos: Vector3, real_size: float) -> Array[Node]:
	var half = (real_size - Grid.cell_size) / 2
	var min_a = grid_pos - Vector3(half, 0, half)
	var max_a = grid_pos + Vector3(half, 0, half)

	# Check overlap with blockers
	var collisions: Array[Node] = []
	
	var gridBlockers = get_tree().get_nodes_in_group("GridBlocker") as Array[GridBlocker]
	for blockers in gridBlockers:
		if(blockers.is_in_group("Preview")):
			continue
		
		var other_position = Grid.to_grid_cord(blockers.global_position)
		var other_size = blockers.size * Grid.cell_size
		
		var half_b = (other_size - Grid.cell_size) / 2
		var min_b = other_position - Vector3(half_b, 0 , half_b)
		var max_b = other_position + Vector3(half_b, 0 , half_b)
		
		var overlap = !(
			max_a.x < min_b.x || min_a.x > max_b.x ||
			max_a.z < min_b.z || min_a.z > max_b.z
		)
		
		if overlap:
			collisions.push_back(blockers.get_parent())
	
	return collisions
