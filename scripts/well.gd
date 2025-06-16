extends Node3D

@onready var affect_area: MeshInstance3D = $AffectArea

func _ready() -> void:
	affect_area.hide()

func _mouse_entered() -> void:
	affect_area.show()

func _mouse_exited() -> void:
	affect_area.hide()
