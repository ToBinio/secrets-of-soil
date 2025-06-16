extends Node3D
class_name Field

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		
		if !Events.selected_plant:
			return
		
		if !is_valid_location(event_position):
			return
		
		var plant_scene = Plants.get_scene_for_plant(Events.selected_plant)
		var plant_instance = plant_scene.instantiate() as Plant
		
		add_child(plant_instance)
		
		plant_instance.global_position = Grid.to_grid_cord(event_position)  

func is_valid_location(location: Vector3) -> bool:
	var grid_pos = Grid.to_grid_cord(location)		
	return !Grid.is_overlapping_blocker(grid_pos, Events.selected_plant.size)
