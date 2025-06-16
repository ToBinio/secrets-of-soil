extends Control
class_name QuestIcon

@export var requirement: QuestRequirementResource:
	set(value):
		requirement = value

@onready var label: Label = $QuantityAmount;
@onready var icon: TextureRect = $Icon;
		

func _ready() -> void:
	set_label_text()
	icon.texture = requirement.plant_resource.icon
	
func _process(delta: float) -> void:
	set_label_text()
	
func set_label_text():
	var data = Inventory.plants[requirement.plant_resource];
		
	label.text = str(data.harvested)+"/"+str(requirement.required_amount)
