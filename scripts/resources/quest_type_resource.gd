extends Resource
class_name QuestTypeResource

@export var name: String;
@export_range(0,3) var difficulty_multiplier 
@export_multiline var description: String;
@export var icon: Texture2D;
