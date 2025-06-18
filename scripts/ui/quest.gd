extends Control
class_name Quest

@export var requirement_scene: PackedScene

@export var quest: QuestResource

@onready var quest_type: QuestType = $QuestType;
@onready var requirements_parent: HBoxContainer = $Requirements;

func _ready() -> void:
	quest_type.quest_type = quest.type;
	
	var children = requirements_parent.get_children()
	for child in children:
		child.free()
	
	for requirement in quest.requirements:
		var scene: QuestIcon = requirement_scene.instantiate() as QuestIcon;
		scene.requirement = requirement;
		
		requirements_parent.add_child(scene)
