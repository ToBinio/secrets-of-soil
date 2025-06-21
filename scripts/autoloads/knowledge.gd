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
	
	var new_found = false
	
	while not plants.is_empty():
		plants.shuffle()
		var plant = plants.pop_front()
		var knowledge = plant_knowledge[plant]
		
		if not knowledge.food:
			knowledge.food = true
			new_found = true
			break
			
		if not knowledge.growth_speed:
			knowledge.growth_speed = true
			new_found = true
			break
		
		if not knowledge.village_preferance:
			knowledge.village_preferance = true
			new_found = true
			break
			
		if not knowledge.water:
			knowledge.water = true
			new_found = true
			break
		
		var index = knowledge.additional.find(false)
		
		if (index == -1):
			continue
		
		knowledge.additional[index] = true
		new_found = true
		break
	
	if(new_found):
		print("learned something new about a plant")
		GameManager.instant(self).stats.knowledge_gathered += 1
	else:
		printerr("nothing to learn anymore :(")

func try_add_new_plant(plant: PlantResource):
	if known_plants.has(plant):
		return
	
	print("learned new plant: ", plant.name)
	GameManager.instant(self).stats.knowledge_gathered += 1
	known_plants.push_back(plant)


func try_add_general_knowledge(knowledge: GeneralKnowledgeResource):
	if general_knowledge.has(knowledge):
		return
	
	print("learned new knowledge: ", knowledge.name)
	GameManager.instant(self).stats.knowledge_gathered += 1
	general_knowledge.push_back(knowledge)
