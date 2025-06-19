extends Button
class_name GeneralKnowledgeButton

@export var general_knowledge: GeneralKnowledgeResource:
	set(value):
		general_knowledge = value
		text = general_knowledge.name
		
@onready var title: Label = $"../../../KnowledgeTitle";
@onready var description: Label = $"../../../GeneralKnowlegeContainer/GeneralKnowledge";

func _on_button_down() -> void:
	title.text = general_knowledge.name;
	description.text = general_knowledge.description
