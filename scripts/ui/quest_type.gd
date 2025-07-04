extends TextureRect
class_name QuestType

@onready var tooltip: Control = $Tooltip;
@onready var type_name: Label = $Tooltip/Name;
@onready var type_description: Label = $Tooltip/Description;


@export var quest_type: QuestTypeResource:
	set(value):
		quest_type = value;
		set_type()

func set_type():
	if not is_node_ready():
		return
	
	type_name.text = quest_type.name;
	type_description.text = quest_type.description;
	texture = quest_type.icon

func _ready() -> void:
	tooltip.visible = false

func _on_mouse_entered() -> void:
	tooltip.visible = true

func _on_mouse_exited() -> void:
	tooltip.visible = false
