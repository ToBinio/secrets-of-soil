extends Control
class_name Quest

signal done
signal discard

@export var can_trash: bool:
	set(value):
		can_trash = value
		if discard_button:
			if can_trash:
				discard_button.show()
			else:
				discard_button.hide()

@export var requirement_scene: PackedScene

@export var quest: QuestResource

@onready var quest_type: QuestType = $CompleteButton/QuestType;
@onready var requirements_parent: HBoxContainer = $Requirements;
@onready var discard_button: TextureButton = $CompleteButton/DiscardButton

func _ready() -> void:
	quest_type.quest_type = quest.type;
	
	var children = requirements_parent.get_children()
	for child in children:
		child.free()
	
	for requirement in quest.requirements:
		var scene: QuestIcon = requirement_scene.instantiate() as QuestIcon;
		scene.requirement = requirement;
		
		requirements_parent.add_child(scene)

func _is_done() -> bool:
	for requirement in quest.requirements:
		if Inventory.plants[requirement.plant_resource].harvested < requirement.required_amount:
			return false
			
	return true

func _on_finish_button_pressed() -> void:
	if not _is_done():
		return
	
	done.emit()

func _on_discard_button_pressed() -> void:
	discard.emit()
