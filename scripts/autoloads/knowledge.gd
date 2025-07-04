extends Node
class_name KnowledgeClass

var known_plants: Array[PlantResource] = []
var plant_knowledge: Dictionary[PlantResource, PlantKnowledge] = {}
var general_knowledge: Array[GeneralKnowledgeResource] = []

class PlantKnowledge:
	var water: bool = false
	var food: bool = false
	var village_preferance: bool = false
	var growth_speed: bool = false
	var additional: Array[bool] = []

func _ready() -> void:
	for plant in Plants.all_plants():
		var knowledge =  PlantKnowledge.new()
		
		for i in plant.additional_facts:
			knowledge.additional.push_back(false)
		
		plant_knowledge.set(plant,knowledge)

func disover_random_plant_knowledge():
	var plants = known_plants.duplicate()
	
	while not plants.is_empty():
		plants.shuffle()
		var plant = plants.pop_front()
		
		if discover_knowledge_for_plant(plant):
			print("learned something new about a plant")
			GameManager.instant(self).stats.knowledge_gathered += 1
			
			Events.new_knowledge()
			return
	
	printerr("nothing to learn anymore :(")

func has_plant_to_research() -> bool:
	for plant in known_plants:
		var knowledge = plant_knowledge[plant]
		
		if(not knowledge.food || not knowledge.growth_speed || not knowledge.village_preferance || not knowledge.village_preferance):
			return true
	
	return false

func discover_knowledge_for_plant(plant: PlantResource):
	var knowledge = plant_knowledge[plant]
	
	if not knowledge.food:
		knowledge.food = true
		return true
		
	if not knowledge.water:
		knowledge.water = true
		return true
		
	if not knowledge.growth_speed:
		knowledge.growth_speed = true
		return true
	
	if not knowledge.village_preferance:
		knowledge.village_preferance = true
		return true
	
	return false

func try_add_new_plant(plant: PlantResource):
	if known_plants.has(plant):
		return
	
	print("learned new plant: ", plant.name)
	GameManager.instant(self).stats.knowledge_gathered += 1
	known_plants.push_back(plant)
	Events.new_knowledge()


func try_add_general_knowledge(knowledge: GeneralKnowledgeResource) -> bool:
	if general_knowledge.has(knowledge):
		return false
	
	print("learned new knowledge: ", knowledge.name)
	GameManager.instant(self).stats.knowledge_gathered += 1
	general_knowledge.push_back(knowledge)
	Events.new_knowledge()
	
	return true
