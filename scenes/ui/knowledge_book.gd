extends Control

@onready var buttons: VBoxContainer = $Background/Sidebar/GeneralKnowledge/KnowledgeSelector;
@export var GeneralButtonScene: PackedScene
@export var PlantButtonScene: PackedScene
@export var click_sound: AudioStream;
@onready var plant_panel: Panel = $Background/PlantKnowledgeContainer;
@onready var general_panel: Panel = $Background/GeneralKnowlegeContainer;

@export var button_group: ButtonGroup

var changed = true;

var general = true;

func _ready() -> void:
	for child in buttons.get_children():
		buttons.remove_child(child);

func _process(_delta: float) -> void:
	if general:
		plant_panel.visible = false;
		general_panel.visible = true;
		
		for knowledge in Knowledge.general_knowledge:
			if buttons.get_children().any(func(child): return child.general_knowledge == knowledge):
				continue
			
			var button = GeneralButtonScene.instantiate();
			button.general_knowledge = knowledge;
			button.button_group = button_group
			
			buttons.add_child(button)
	else:
		plant_panel.visible = true;
		general_panel.visible = false;
		
		for plant in Knowledge.known_plants:
			if buttons.get_children().any(func(child): return child.plant == plant):
				continue
				
			var button = PlantButtonScene.instantiate();
			button.plant = plant;
			button.plant_knowledge = Knowledge.plant_knowledge[plant];
			button.button_group = button_group
			
			buttons.add_child(button)
	
	if changed:
		if buttons.get_child_count() > 0:
			buttons.get_children()[0].set_pressed(true)
			buttons.get_children()[0].pressed.emit()
			
		changed = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			visible = false
			
			var player = AudioStreamPlayer2D.new();
			player.volume_db = -10;
			player.stream = click_sound;
			get_tree().root.add_child(player)
			player.playing = true
			player.finished.connect(func(): player.queue_free())


func _on_plant_pressed() -> void:
	general = false
	changed = true
	
	for child in buttons.get_children():
		buttons.remove_child(child);

func _on_general_pressed() -> void:
	general = true
	changed = true
	
	for child in buttons.get_children():
		buttons.remove_child(child);
