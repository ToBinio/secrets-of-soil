extends Resource
class_name PlantResource

@export var name: String
@export_multiline var description: String 

@export var food: int
@export var growth_speed: float
@export var icon: Texture2D

@export var growth_effecency: Curve
@export_range(0,1) var village_preferance: float

@export var additional_facts: Array[String]
