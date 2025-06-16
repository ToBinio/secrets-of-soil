extends Camera3D

@export_group("zoom")
@export var zoom_speed: float = 0.05;  
@export var zoom_animation_speed: float = 1.0
@export var max_zoom: float
@export var min_zoom: float

var _plane = Plane(Vector3.UP)
var _prevous_mouse_location: Vector2;

var _target_zoom: float = position.y

func _process(delta: float) -> void:
	position.y = lerp(position.y, _target_zoom, zoom_animation_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_RIGHT:
				_prevous_mouse_location = event.position
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_target_zoom /= 1 + zoom_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_target_zoom *= 1 + zoom_speed
			
			_target_zoom = clamp(_target_zoom, min_zoom, max_zoom)

	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			if(!_prevous_mouse_location):
				return
			
			position -= (_get_3d_mouse_postion(event.position) - _get_3d_mouse_postion(_prevous_mouse_location))
			_prevous_mouse_location = event.position

func _get_3d_mouse_postion(postion: Vector2) -> Vector3:
	var ray_origin = project_ray_origin(postion)
	var ray_direction = project_ray_normal(postion)
	
	var intersection = _plane.intersects_ray(ray_origin, ray_direction)
	
	return intersection;
