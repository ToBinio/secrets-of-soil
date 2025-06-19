extends Button
class_name PlantKnowledgeButton

var plant: PlantResource:
	set(value):
		plant = value
		text = plant.name
var plant_knowledge: KnowledgeClass.PlantKnowledge;
		
@onready var title: Label = $"../../../KnowledgeTitle";
@onready var description: Label = $"../../../PlantKnowledgeContainer/Description";
@onready var plant_icon: TextureRect = $"../../../PlantKnowledgeContainer/Icon";
@onready var water_graph: WaterGraph = $"../../../PlantKnowledgeContainer/WaterGraph";
@onready var food: Label = $"../../../PlantKnowledgeContainer/Food";
@onready var villager_preference: Label = $"../../../PlantKnowledgeContainer/VillagerPreference";

func _on_button_down() -> void:
	title.text = plant.name;
	description.text = plant.description;
	plant_icon.texture = plant.icon
	
	if plant_knowledge.water:
		water_graph.curve = plant.growth_effecency
	
	if plant_knowledge.food:
		food.text = "Food: " + str(plant.food)
	else:
		food.text = "Food: Currently unknown, must be researched!"
		
	if plant_knowledge.village_preferance:
		villager_preference.text = "Villager Preference: " + str(plant.village_preferance)
	else:
		villager_preference.text = "Villager Preference: Currently unknown, must be researched!"

	
