extends Control

var RequirementScene = preload("res://scenes/ui/quest_icon.tscn");

@export var quest: QuestResource;

@onready var quest_type: QuestType = $QuestType;
@onready var requirements_parent: HBoxContainer = $Requirements;


func _ready() -> void:
	quest_type.quest_type = quest.type;
	
	for requirement in quest.requirements:
		var requirement_scene: QuestIcon = RequirementScene.instantiate();
		requirement_scene.requirement = requirement;
		
		requirements_parent.call_deferred("add_child", requirement_scene)
