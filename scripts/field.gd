extends Node3D
class_name Field

@export_range(0, 1) var water_level: float

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		
		if !Events.selected_plant:
			return
		
		if !is_valid_location(event_position):
			return
		
		var plant_scene = Plants.get_scene_for_plant(Events.selected_plant)
		
		var plant_instance = plant_scene.instantiate() as Plant
		plant_instance.field = self
		
		add_child(plant_instance)
		
		plant_instance.global_position = Grid.to_grid_cord(event_position)  

func is_valid_location(location: Vector3) -> bool:
	var grid_position = Grid.to_grid_cord(location)
	var size = Events.selected_plant.size * Grid.cell_size
	var half = (size - Grid.cell_size) / 2
	var min_a = grid_position - Vector3(half, 0, half)
	var max_a = grid_position + Vector3(half, 0, half)
	
	var gridBlockers = get_tree().get_nodes_in_group("GridBlocker") as Array[GridBlocker]
	for blockers in gridBlockers:
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
			return false
	
	return true
