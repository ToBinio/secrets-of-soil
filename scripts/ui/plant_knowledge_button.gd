extends Button
class_name PlantKnowledgeButton

var plant: PlantResource:
	set(value):
		plant = value
		text = plant.name
var plant_knowledge: KnowledgeClass.PlantKnowledge;
		
@onready var title: Label = $"../../../../KnowledgeTitle";
@onready var description: Label = $"../../../../PlantKnowledgeContainer/Description";
@onready var plant_icon: TextureRect = $"../../../../PlantKnowledgeContainer/Icon";
@onready var water: Control = $"../../../../PlantKnowledgeContainer/Water";
@onready var water_graph: WaterGraph = $"../../../../PlantKnowledgeContainer/Water/WaterGraph";

@onready var food: Label = $"../../../../PlantKnowledgeContainer/Food/Value";
@onready var food_container: Control = $"../../../../PlantKnowledgeContainer/Food";

@onready var days: Label = $"../../../../PlantKnowledgeContainer/Growth/Value";
@onready var days_container: Control = $"../../../../PlantKnowledgeContainer/Growth";

@onready var villager_preference: Label = $"../../../../PlantKnowledgeContainer/Preference/Value";
@onready var villager_preference_container: Control = $"../../../../PlantKnowledgeContainer/Preference";

@export var click_sound: AudioStream;

func _on_pressed() -> void:
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
	player.finished.connect(func(): player.queue_free())
	
	title.text = plant.name;
	description.text = plant.description;
	plant_icon.texture = plant.icon
	
	if plant_knowledge.water:
		water.show()
		water_graph.curve = plant.growth_effecency
	else:
		water.hide()
		
	if plant_knowledge.food:
		food_container.show()
		food.text = "" + str(plant.food)
	else:
		food_container.hide()
		
	if plant_knowledge.village_preferance:
		villager_preference_container.show()
		villager_preference.text = str(int(plant.village_preferance * 100))
	else:
		villager_preference_container.hide()
		
	if plant_knowledge.growth_speed:
		days_container.show()
		days.text = "%.2f" % (1. / plant.growth_speed)
	else:
		days_container.hide()
