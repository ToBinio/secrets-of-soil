extends Node
class_name GameManager

var current_day: int;
var current_food_requirements: int;

var _current_weather: int

@export var possible_weather: Array[WeatherResource]
@export var structures: Array[PackedScene]

@export var default_plants: Dictionary[PlantResource, int]

func current_weather() -> WeatherResource:
	return possible_weather[_current_weather]

func _ready() -> void:
	current_day = 1
	current_food_requirements = _calc_food_requirement()
	_current_weather = possible_weather.size() / 2
	
	for key in default_plants.keys():
		Inventory.plants[key].max_seeds = default_plants[key]
	
	_reset_inventory()
	
	Events.on_next_day.connect(_on_next_day)
		
func _on_next_day():
	_consume_food()
	
	_remove_random_structure()
	_try_generate_random_structure()
	
	# needed to make sure plants have grown before stuff changes
	await get_tree().create_timer(1).timeout
	
	current_day += 1
	current_food_requirements = _calc_food_requirement()
	
	_update_weather()
	
	_reset_inventory()

func _update_weather():
	var center = (possible_weather.size() - 1) / 2.0
	var diff = _current_weather - center

	var change = randi_range(-1,1)
	
	if randf() < 0.2:
		change = clamp(-diff, -1,1)
			
	_current_weather = clamp(_current_weather + change, 0, possible_weather.size() - 1)

func _calc_food_requirement() -> int:
	return (current_day - 1) * 10

func _consume_food():
	var to_eat = current_food_requirements
	
	while to_eat > 0:
		var plants: Array[PlantResource] = []
		
		for plant_key in Inventory.plants.keys():
			for i in Inventory.plants[plant_key].harvested:
				plants.push_back(plant_key)
		
		if plants.is_empty():
			printerr("you lost! - no more plants to eat - " + str(to_eat))
			return
		
		var eat = plants.pick_random() as PlantResource
		to_eat -= eat.food
		Inventory.plants[eat].harvested -= 1

func _remove_random_structure():
	var generated = get_tree().get_nodes_in_group("Generated")
	
	if generated.size() < 8:
		return
	
	generated.pick_random().queue_free()

func _try_generate_random_structure():
	for n in 5:
		if _generate_random_structure():
			break

func _generate_random_structure() -> bool:
	var structure = structures.pick_random() as PackedScene;
	var strucuter_instance = structure.instantiate() as Node3D
	
	var x = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	var z = randi_range(-Grid.grid_size,Grid.grid_size + 1)
	
	var global_position = Vector3(x * Grid.cell_size, 0.01, z * Grid.cell_size)
	
	var plants = Grid.is_valid_location_ignore_plants(global_position, strucuter_instance);
	
	if plants is bool && plants == false:
		return false
	
	for plant in plants:
		plant.queue_free()
	
	add_child(strucuter_instance)
	
	strucuter_instance.global_position = global_position
	strucuter_instance.add_to_group("Generated")
	
	return true

func _reset_inventory():
	for key in Inventory.plants.keys():
		Inventory.plants[key].seeds = Inventory.plants[key].max_seeds
