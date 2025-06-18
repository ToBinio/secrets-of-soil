extends VBoxContainer

@export var quest_scene: PackedScene
@export var possible_quest_types: Array[QuestTypeResource];

func _ready() -> void:
	for child in get_children():
		child.free()
	
	_add_new_quest()
	_add_new_quest()
	_add_new_quest()

func _add_new_quest():
	var quest = _generate_random_quest()
	var scene = quest_scene.instantiate() as Quest
	scene.quest = quest
	
	add_child(scene)

func _generate_random_quest() -> QuestResource:
	var quest = QuestResource.new()
	
	quest.type = possible_quest_types.pick_random()
	
	var possible_plants = Plants.all_plants()
	
	var number_of_requirements = randi_range(1,3)
	for i in number_of_requirements:
		if(possible_plants.size() <= 0):
			break
		
		var quest_requirement = QuestRequirementResource.new()
		
		var plant_index = randi_range(0, possible_plants.size() - 1);
		
		quest_requirement.plant_resource = possible_plants[plant_index]
		possible_plants.remove_at(plant_index)
		
		quest_requirement.required_amount = randi_range(5, 10);
		
		quest.requirements.push_back(quest_requirement)
	
	return quest
