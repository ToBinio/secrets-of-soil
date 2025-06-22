extends Node3D
class_name Field

@export var preview_color: Color
@export var invalid_preview_color: Color

@export var ground_material: StandardMaterial3D 
@export var place_sound: AudioStream;

@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer;
var preview: PlantPreview;

func _process(delta: float) -> void:
	var game_manager = GameManager.instant(self)
	ground_material.albedo_color = ground_material.albedo_color.lerp(game_manager.current_weather().ground_color ,delta)
	

func _on_mouse_exited() -> void:
	if(preview):
		preview.queue_free()
		preview = null

func _try_add_preview():
	if(Events.selected_plant && !preview):
		var plant_scene = Plants.get_preview_for_plant(Events.selected_plant)
		var plant_instance = plant_scene.instantiate() as PlantPreview
		
		plant_instance.set_color(preview_color)
		
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
			
			if is_valid(event_position, preview):
				preview.set_color(preview_color)
			else:
				preview.set_color(invalid_preview_color)
	
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		
		if !Events.selected_plant:
			return
		
		var plant_scene = Plants.get_scene_for_plant(Events.selected_plant)
		var plant_instance = plant_scene.instantiate() as Plant
		
		if !is_valid(event_position, plant_instance):
			return
		
		preview.set_color(invalid_preview_color)
		Inventory.plants[Events.selected_plant].seeds -= 1
		
		# Play place sound
		audio_player.stream = place_sound
		audio_player.playing = true
		
		if(Inventory.plants[Events.selected_plant].seeds <= 0):
			Events.selected_plant = null
		
		plant_instance.position = Grid.to_grid_cord(event_position)  
		plant_instance.position.y = 0.05
		
		add_child(plant_instance)
		

func is_valid(location: Vector3, node: Node) -> bool:
	if Inventory.plants[Events.selected_plant].seeds <= 0:
		return false
	
	var grid_pos = Grid.to_grid_cord(location)
	return Grid.is_valid_location(grid_pos, node)
