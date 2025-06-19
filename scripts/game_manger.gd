extends Node
class_name GameManager

class Stats:
	var days_survived: int = 0
	var food_consumed: int = 0
	var plants_harvested: int = 0
	var knowledge_gathered: int = 0
	var plants_destroyed_by_village: int = 0
	var quests_completed: int = 0

var stats: Stats = Stats.new() 

var current_food_requirements: int;
var _current_weather: int

@export var possible_weather: Array[WeatherResource]

@export var houses: Array[PackedScene]
@export var housing_radius: int
@export var water_sources: Array[PackedScene]
@export_range(0,1) var water_source_change: float

@export var default_plants: Dictionary[PlantResource, int]

@export var day_night_cycle_duration: int = 4
var is_doing_day_night_cycle: bool

@export var death_screen: Control
@export var can_die: bool

static func instant(node: Node) -> GameManager:
	return node.get_tree().get_first_node_in_group("GameManager") as GameManager

func current_weather() -> WeatherResource:
	return possible_weather[_current_weather]

func _ready() -> void:
	death_screen.hide()
	
	current_food_requirements = _calc_food_requirement()
	_current_weather = floor(possible_weather.size() / 2.)
	
	for key in default_plants.keys():
		Inventory.plants[key].max_seeds = default_plants[key]
	
	_reset_inventory()
	is_doing_day_night_cycle = false
	
	Events.on_next_day.connect(_on_next_day)

func _on_next_day():
	is_doing_day_night_cycle = true
	
	if !_consume_food() && can_die:
		death_screen.show()
		return
	
	_remove_random_structure()
	_try_generate_random_structure()
	
	# needed to make sure plants have grown before stuff changes
	await get_tree().create_timer(day_night_cycle_duration / 2.).timeout
	
	stats.days_survived += 1
	current_food_requirements = _calc_food_requirement()
	
	_update_weather()
	
	_reset_inventory()
	
	await get_tree().create_timer(day_night_cycle_duration / 2.).timeout
	is_doing_day_night_cycle = false

func _update_weather():
	var center = (possible_weather.size() - 1) / 2.0
	var diff = _current_weather - center

	var change = randi_range(-1,1)
	
	if randf() < 0.2:
		change = clamp(-diff, -1,1)
			
	_current_weather = clamp(_current_weather + change, 0, possible_weather.size() - 1)

func _calc_food_requirement() -> int:
	return stats.days_survived * 10

func _consume_food() -> bool:
	var to_eat = current_food_requirements
	
	while to_eat > 0:
		var plants: Array[PlantResource] = []
		
		for plant_key in Inventory.plants.keys():
			for i in Inventory.plants[plant_key].harvested:
				plants.push_back(plant_key)
		
		if plants.is_empty():
			return false
		
		var eat = plants.pick_random() as PlantResource
		
		to_eat -= eat.food
		stats.food_consumed += eat.food
		
		Inventory.plants[eat].harvested -= 1
		
	return true

func _remove_random_structure():
	var generated = get_tree().get_nodes_in_group("Generated")
	
	if generated.size() < 8:
		return
	
	generated.pick_random().queue_free()

func _try_generate_random_structure():
	for n in 10:
		if randf() < water_source_change:
			if _generate_random_water_source(): return
		else:
			if _generate_random_housing(): return

func _generate_random_housing() -> bool:
	var structure = houses.pick_random() as PackedScene;
	
	var x = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	var z = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	
	var result =  _try_spawn_structure(structure, x, z, self);
	
	if not result[0]:
		return false
	
	result[1].add_to_group("Generated")
	
	for i in 10:
		var structure_addition = houses.pick_random() as PackedScene;
		
		var x_addition = randi_range(x - housing_radius, x + housing_radius)
		var z_addition = randi_range(z - housing_radius, z + housing_radius)
		
		_try_spawn_structure(structure_addition, x_addition, z_addition, result[1])
	
	return true

func _generate_random_water_source() -> bool:
	var structure = water_sources.pick_random() as PackedScene;
	
	var x = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	var z = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	
	var result = _try_spawn_structure(structure, x, z, self)
	
	if not result[0]:
		return false
	
	result[1].add_to_group("Generated")
	return true

func _try_spawn_structure(structure: PackedScene, x: int, z: int, parent: Node):
	var strucuter_instance = structure.instantiate() as Node3D
	
	var global_position = Vector3(x * Grid.cell_size, 0.01, z * Grid.cell_size)
	
	var plants = Grid.is_valid_location_ignore_plants(global_position, strucuter_instance);
	
	if plants is bool && plants == false:
		return [false, null]
	
	for plant in plants:
		stats.plants_destroyed_by_village += 1
		plant.queue_free()
	
	parent.add_child(strucuter_instance)
	
	strucuter_instance.global_position = global_position
	strucuter_instance.rotate_y(PI / 2. * randi_range(0,3))
	
	return [true, strucuter_instance]

func _reset_inventory():
	for key in Inventory.plants.keys():
		Inventory.plants[key].seeds = Inventory.plants[key].max_seeds
