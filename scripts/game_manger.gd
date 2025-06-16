extends Node

@export var structures: Array[PackedScene]
@export var default_plants: Dictionary[PlantResource, int]

func _ready() -> void:
	for key in default_plants.keys():
		Inventory.plants[key].max_seeds = default_plants[key]
	
	_reset_inventory()
	
	Events.on_next_day.connect(_on_next_day)
		
func _on_next_day():
	_reset_inventory()
	
	_remove_random_structure()
	_try_generate_random_structure()

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
