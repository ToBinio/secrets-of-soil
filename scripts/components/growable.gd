extends Node
class_name Growable

signal on_fully_grown

@export var plant: Plant
@export var visual: Node3D
@export var happiness_label: Label3D

var target_size = 0.1

func _ready() -> void:
	Events.on_next_day.connect(_on_next_day)
	visual.scale = Vector3.ONE * target_size;
	
func _process(delta: float) -> void:
	visual.scale = lerp(visual.scale, Vector3.ONE *  target_size, delta * 5);

func _calc_growth_factor() -> float:
	var grid_pos = Grid.to_grid_cord(plant.global_position)
	var water_level = Grid.get_water_percentage(grid_pos)
	
	var game_manger = get_tree().get_first_node_in_group("GameManager") as GameManager
	
	water_level += game_manger.current_weather().water_change
	water_level = clamp(water_level,0,1)
	
	var growth_factor = 1 - abs(plant.plant.preferred_water - water_level)
	
	return growth_factor

func _on_next_day():
	var growth_factor = _calc_growth_factor()
	
	if happiness_label:
		happiness_label.text = "Happy: %.2f" % growth_factor
	
	target_size = min(target_size + growth_factor * plant.plant.growth_speed, 1)
	
	if(target_size == 1):
		on_fully_grown.emit()
