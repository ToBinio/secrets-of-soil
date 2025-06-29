extends VBoxContainer

@export var quest_scene: PackedScene
@export var possible_quest_types: Array[QuestTypeResource];

@export var discovery_quest_type: QuestTypeResource
@export var research_quest_type: QuestTypeResource

@onready var player: AudioStreamPlayer2D = $"../../../AudioStreamPlayer2D";
@export var quest_complete: AudioStream;

var quests: Array[Quest] = [];

func _ready() -> void:
	for child in get_children():
		child.free()
	
	_add_new_quest()
	_add_new_quest()
	_add_new_quest()
	
	Events.on_next_day.connect(_on_next_day)

func _on_next_day():
	for quest in quests:
		quest.can_trash = true
	
	while quests.size() < 3:
		_add_new_quest()

func _add_new_quest():
	var quest = _generate_random_quest()
	
	for existing_quest in quests:
		if existing_quest.quest.type == quest.type:
			quest = _generate_random_quest()
			break
	
	var scene = quest_scene.instantiate() as Quest
	
	scene.done.connect(func(): _on_quest_done(quest, scene))
	scene.discard.connect(func(): _on_quest_discard(scene))
	
	scene.quest = quest
	
	add_child(scene)
	quests.push_back(scene)

func _on_quest_done(quest: QuestResource, scene: Quest):
	for requirement in quest.requirements:
		Inventory.plants[requirement.plant_resource].harvested -= requirement.required_amount
	
	scene.queue_free()
	
	_exec_quest(quest)
	
	GameManager.instant(self).stats.quests_completed += 1
	
	var index = quests.find(scene)
	quests.remove_at(index)
	
	player.stream = quest_complete;
	player.playing = true

func _exec_quest(quest: QuestResource):
	match quest.type.name:
		"Discover":
			print("execute quest `Discover`")
			var to_discorver = Inventory.undiscoverd_plants().pick_random()
			
			if(not to_discorver):
				printerr("no Plants left to discover")
				return
			
			Knowledge.try_add_new_plant(to_discorver)
			
			var seeds = randi_range(1,3)
			
			Inventory.plants[to_discorver].max_seeds = seeds
			Inventory.plants[to_discorver].seeds = seeds
			
			if(Inventory.undiscoverd_plants().is_empty()):
				possible_quest_types.remove_at(possible_quest_types.find(discovery_quest_type))
				_reduce_quests()
				
			if not possible_quest_types.has(research_quest_type):
				possible_quest_types.push_back(research_quest_type)
			
		"Sun Dance":
			print("execute quest `Sun Dance`")
			GameManager.instant(self).set_weather_bias(-1)
		"Rain Dance":
			print("execute quest `Rain Dance`")
			GameManager.instant(self).set_weather_bias(1)
		"Research":
			print("execute quest `Research`")
			Knowledge.disover_random_plant_knowledge()
			Knowledge.disover_random_plant_knowledge()
			
			if(not Knowledge.has_plant_to_research()):
				possible_quest_types.remove_at(possible_quest_types.find(research_quest_type))
				_reduce_quests()
		"Seeds":
			print("execute quest `Seeds`")
			var plant = Inventory.discoverd_plants().pick_random()
			
			if(not plant):
				printerr("no Plants left to discover")
				return
			
			var seeds = randi_range(2,5)
			
			Inventory.plants[plant].max_seeds += seeds
			Inventory.plants[plant].seeds += seeds
		"Weather":
			print("execute quest `Weather`")
			var game_manager = GameManager.instant(self)
			
			for i in 5:
				game_manager.add_weather()
		_:
			printerr("unknown quest type ", quest.type.name)

func _on_quest_discard(scene: Quest):
	for quest in quests:
		quest.can_trash = false
		
	scene.queue_free()
	var index = quests.find(scene)
	quests.remove_at(index)

func _reduce_quests():
	for i in range(quests.size() - 1, -1, -1):
		print(i)
		var quest = quests[i] as Quest
		if not possible_quest_types.has(quest.quest.type):
			quest.queue_free()
			quests.remove_at(i)

func _generate_random_quest() -> QuestResource:
	var quest = QuestResource.new()
	
	quest.type = possible_quest_types.pick_random()
	
	var possible_plants = Inventory.plants_with_seeds()
	
	var plant_sum = 0;
	
	var number_of_requirements = randi_range(1,3)
	for i in number_of_requirements:
		if(possible_plants.size() <= 0):
			break
		
		var quest_requirement = QuestRequirementResource.new()
		
		var plant_index = randi_range(0, possible_plants.size() - 1);
		
		quest_requirement.plant_resource = possible_plants[plant_index]
		possible_plants.remove_at(plant_index)
		
		quest_requirement.required_amount = randi_range(2, 5) * quest.type.difficulty_multiplier;
		quest.requirements.push_back(quest_requirement)
		
		plant_sum += quest_requirement.required_amount
		
		if(plant_sum >= 5 * quest.type.difficulty_multiplier):
			break
	
	return quest
