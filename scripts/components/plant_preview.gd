extends Node3D
class_name PlantPreview

@export var plant: PlantResource
@export var grid_blocker: GridBlocker

@export var preview_materials: Array[StandardMaterial3D]

func _ready() -> void:
	grid_blocker.size = plant.size

func set_color(color: Color):
	for material in preview_materials:
		material.albedo_color = color
