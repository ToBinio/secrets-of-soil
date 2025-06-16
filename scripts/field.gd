extends Node3D
class_name Field

var preview: Plant;

func _on_mouse_exited() -> void:
	if(preview):
		preview.queue_free()
		preview = null

func _try_add_preview():
	if(Events.selected_plant && !preview):
		var plant_scene = Plants.get_scene_for_plant(Events.selected_plant)
		var plant_instance = plant_scene.instantiate() as Plant
		
		add_child(plant_instance)
		
		preview = plant_instance

func _try_remove_preview():
	if !preview:
		return
	
	if(!Events.selected_plant || Events.selected_plant != preview.plant ):
		preview.queue_free()
		preview = null

func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		_try_remove_preview()
		_try_add_preview()
		
		if preview:
			preview.global_position = Grid.to_grid_cord(event_position)  
	
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
