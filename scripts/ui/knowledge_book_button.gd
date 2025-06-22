extends Button
class_name KnowledgeBookButton

@onready var knowledge_book = $"../KnowledgeBook";
@onready var info: Control = $Info

@export var click_sound: AudioStream;
@export var notification_sound: AudioStream;

func _ready() -> void:
	Events.on_new_knowledge.connect(func(): 
		info.show()
		
		var player = AudioStreamPlayer2D.new();
		player.volume_db = -10;
		player.stream = notification_sound;
		get_tree().root.add_child(player)
		player.playing = true
		player.finished.connect(func(): player.queue_free())
	)
	info.hide()

func _on_button_down() -> void:
	knowledge_book.visible = not knowledge_book.visible
	info.hide()
	
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
	player.finished.connect(func(): player.queue_free())
