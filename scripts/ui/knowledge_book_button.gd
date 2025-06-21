extends Button
class_name KnowledgeBookButton

@onready var knowledge_book = $"../KnowledgeBook";
@export var click_sound: AudioStream;

func _on_button_down() -> void:
	knowledge_book.visible = not knowledge_book.visible
	
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
