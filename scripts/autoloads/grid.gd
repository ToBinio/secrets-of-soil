extends Node

const cell_size = 0.5

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
	
func is_overlapping_blocker(grid_pos: Vector3, grid_size: float) -> bool:
	var size = grid_size * Grid.cell_size
	
	var half = (size - Grid.cell_size) / 2
	var min_a = grid_pos - Vector3(half, 0, half)
	var max_a = grid_pos + Vector3(half, 0, half)
	
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
			return true
	
	return false
