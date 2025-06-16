extends Node3D
class_name PlantPreview

@export var plant: PlantResource

@export var preview_materials: Array[StandardMaterial3D]

func set_color(color: Color):
	for material in preview_materials:
		material.albedo_color = color
