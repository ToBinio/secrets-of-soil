extends Control

@onready var buttons: VBoxContainer = $Background/GeneralKnowledge/KnowledgeSelector;
@export var GeneralButtonScene: PackedScene
@export var PlantButtonScene: PackedScene
@export var click_sound: AudioStream;
@onready var types: OptionButton = $Background/KnowledgeType;
@onready var plant_panel: Panel = $Background/PlantKnowledgeContainer;
@onready var general_panel: Panel = $Background/GeneralKnowlegeContainer;
var changed = true;

var general = true;

func _ready() -> void:
	types.add_item("General")
	types.add_item("Plants")

func _process(_delta: float) -> void:
	for child in buttons.get_children():
		buttons.remove_child(child);
	
	if general:
		plant_panel.visible = false;
		general_panel.visible = true;
		
		for knowledge in Knowledge.general_knowledge:
			var button = GeneralButtonScene.instantiate();
			button.general_knowledge = knowledge;
			buttons.add_child(button)
	else:
		plant_panel.visible = true;
		general_panel.visible = false;
		
		for plant in Knowledge.known_plants:
			var button = PlantButtonScene.instantiate();
			button.plant = plant;
			button.plant_knowledge = Knowledge.plant_knowledge[plant];
			buttons.add_child(button)
	
	if changed:
		if buttons.get_child_count() > 0:
			buttons.get_children()[0]._on_button_down()
		changed = false

func _on_knowledge_type_item_selected(index: int) -> void:
	general = index == 0
	changed = true
	
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
