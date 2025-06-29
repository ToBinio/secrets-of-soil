extends Node
class_name Growable

signal on_fully_grown

@export var plant: Plant
@export var visual: Node3D

var target_size = 0.1

func _ready() -> void:
	Events.on_next_day.connect(_on_next_day)
	visual.scale = Vector3.ONE * target_size;

func _process(delta: float) -> void:
	visual.scale = lerp(visual.scale, Vector3.ONE *  target_size, delta * 5);

func calc_growth_factor() -> float:
	var grid_pos = Grid.to_grid_cord(plant.global_position)
	var water_level = Grid.get_water_percentage(grid_pos)
	
	var game_manger = GameManager.instant(self)
	
	water_level += game_manger.current_weather().water_change
	water_level = clamp(water_level,0,1)
	
	print("water ",water_level)
	
	var growth_factor = plant.plant.growth_effecency.sample(water_level)
	
	print("factor ",growth_factor)
	
	return growth_factor

func _on_next_day():
	var growth_factor = calc_growth_factor()
	target_size = min(target_size + growth_factor * plant.plant.growth_speed, 1)
	
	if(target_size == 1):
		on_fully_grown.emit()
