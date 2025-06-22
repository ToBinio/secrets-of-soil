extends Node3D

@onready var affect_area: MeshInstance3D = $AffectArea

@export var knowledge: GeneralKnowledgeResource
@export var removal_particles: PackedScene

func _ready() -> void:
	affect_area.hide()

func _mouse_entered() -> void:
	Knowledge.try_add_general_knowledge(knowledge)
	affect_area.show()

func _mouse_exited() -> void:
	affect_area.hide()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		var particles = removal_particles.instantiate()
		if get_parent() && is_inside_tree():
			get_parent().add_child(particles)
			particles.global_position = global_position
