extends Button
class_name GeneralKnowledgeButton

@export var general_knowledge: GeneralKnowledgeResource:
	set(value):
		general_knowledge = value
		text = general_knowledge.name
		
@onready var title: Label = $"../../../../KnowledgeTitle"
@onready var description: Label = $"../../../../GeneralKnowlegeContainer/GeneralKnowledge"

@export var click_sound: AudioStream;

func _on_pressed() -> void:
	title.text = general_knowledge.name;1
	description.text = general_knowledge.description
	
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
	player.finished.connect(func(): player.queue_free())
