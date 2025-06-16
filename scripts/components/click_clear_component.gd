@tool
extends Node3D
class_name GridAreaDisplay

@export var plant: Plant

@onready var mesh: MeshInstance3D = $Mesh

func _ready():
	var plane_mesh = mesh.mesh as PlaneMesh
	
	plane_mesh.size.x = plant.plant.size * Grid.cell_size + 0.02
	plane_mesh.size.y = plant.plant.size * Grid.cell_size + 0.02
