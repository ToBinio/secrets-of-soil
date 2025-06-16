@tool
extends Node3D
class_name GridBlocker

@export var size: int:
	set(value):
		size = value
		_update_size()

@onready var mesh: MeshInstance3D = $Mesh

func _ready():
	_update_size()

func _update_size():
	if(!mesh):
		return
	
	var plane_mesh = mesh.mesh as PlaneMesh
	
	plane_mesh.size.x = size * Grid.cell_size + 0.02
	plane_mesh.size.y = size * Grid.cell_size + 0.02
