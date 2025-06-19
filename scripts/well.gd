extends Node3D

@onready var affect_area: MeshInstance3D = $AffectArea

@export var knowledge: GeneralKnowledgeResource

func _ready() -> void:
	affect_area.hide()

func _mouse_entered() -> void:
	Knowledge.try_add_general_knowledge(knowledge)
	affect_area.show()

func _mouse_exited() -> void:
	affect_area.hide()
