extends Resource
class_name PlantResource

@export var name: String

@export var growth_speed: float
@export var size: int
@export var icon: Texture2D

@export_range(0, 1) var preferred_water: float
