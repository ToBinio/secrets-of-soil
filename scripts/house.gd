extends Node3D

@export var removal_particles: PackedScene

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		var particles = removal_particles.instantiate()
		if get_parent() && is_inside_tree():
			get_parent().add_child(particles)
			particles.global_position = global_position
