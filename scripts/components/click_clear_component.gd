@tool
extends Area3D
class_name ClickClearComponent

@export var radius: float :
	set(value):
		radius = value
		
		if shape:
			shape.shape.radius = radius

@onready var shape: CollisionShape3D = $CollisionShape3D

func _ready():
	shape.shape.radius = radius
