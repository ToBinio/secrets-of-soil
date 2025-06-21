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
var _weather: Array[int] = [0]

var weather_bias: int = 0
var weather_bias_duration: int = 0

@export var possible_weather: Array[WeatherResource]

@export var houses: Array[PackedScene]
@export var housing_radius: int
@export var water_sources: Array[PackedScene]
@export_range(0,1) var water_source_change: float

@export var default_plants: Dictionary[PlantResource, int]
@export var number_of_default_plants: int = 2

@export var day_night_cycle_duration: int = 4
var is_doing_day_night_cycle: bool

@export var death_screen: Control
@export var can_die: bool

@export var weather_knowledge: GeneralKnowledgeResource

static func instant(node: Node) -> GameManager:
	return node.get_tree().get_first_node_in_group("GameManager") as GameManager

func current_weather() -> WeatherResource:
	return possible_weather[_weather[0]]
	
func weather_at(offset: int) -> WeatherResource:
	if(_weather.size() <= offset):
		return null
	
	return possible_weather[_weather[offset]]

func _ready() -> void:
	death_screen.hide()
	
	current_food_requirements = _calc_food_requirement()
	_weather[0] = possible_weather.size() / 2
	
	var plants = default_plants.keys().duplicate()
	
	for i in number_of_default_plants:
		var plant = plants.pick_random()
		
		Knowledge.try_add_new_plant(plant)
		
		Knowledge.discover_knowledge_for_plant(plant)
		Knowledge.discover_knowledge_for_plant(plant)
		
		Inventory.plants[plant].max_seeds = default_plants[plant]
		
		plants.remove_at(plants.find(plant))
	
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
	
	if _weather.size() <= 1:
		add_weather()
	_weather.pop_front()
	
	_reset_inventory()
	
	await get_tree().create_timer(day_night_cycle_duration / 2.).timeout
	is_doing_day_night_cycle = false

func set_weather_bias(bias: int):
	weather_bias = bias
	weather_bias_duration = 5
	
	for index in _weather.size():
		_weather[index] = _weather[index] + weather_bias
		_weather[index] = clamp(_weather[index], 0, possible_weather.size() - 1)
		
		weather_bias_duration -= 1

func add_weather():
	var current_weather = _weather[0]
	
	var center = ((possible_weather.size() - 1) / 2.) + weather_bias
	var diff = current_weather - center

	weather_bias_duration -= 1;
	if weather_bias_duration <= 0:
		weather_bias = 0

	var change = randi_range(-1,1)
	
	if randf() < 0.2:
		change = clamp(-diff, -1,1)
			
	var new_weather = clamp(current_weather + change, 0, possible_weather.size() - 1)
	
	if(new_weather != center):
		Knowledge.try_add_general_knowledge(weather_knowledge)
	
	_weather.push_back(int(new_weather))

func _calc_food_requirement() -> int:
	return stats.days_survived * 10

func _consume_food() -> bool:
	var to_eat = current_food_requirements
	
	var plant_weight = func(plant: PlantResource) -> float:
		return plant.village_preferance * (log(Inventory.plants[plant].harvested) + 1.)
	
	while to_eat > 0:
		var plants: Array[PlantResource] = []
		
		for plant_key in Inventory.plants.keys():
			if(Inventory.plants[plant_key].harvested <= 0):
				continue
			
			if(plant_key.village_preferance <= 0):
				continue
			
			plants.push_back(plant_key)
		
		if plants.is_empty():
			return false
		
		var weight_sum = 0
		
		for plant in plants:
			weight_sum += plant_weight.call(plant)
		
		var eat: PlantResource
		
		var rand = randf_range(0,weight_sum)
		var sum = 0;
		for plant in plants:
			sum += plant_weight.call(plant)
			if(rand <= sum):
				eat = plant
				break
		
		if not eat:
			printerr("something went wrong while eating")
			return false
		
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
