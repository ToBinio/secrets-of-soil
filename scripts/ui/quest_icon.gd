extends Control
class_name QuestIcon

@export var requirement: QuestRequirementResource:
	set(value):
		requirement = value
		_update()

@onready var label: Label = $QuantityAmount;
@onready var icon: TextureRect = $Icon;
 
func _ready() -> void:
	_update()
	
func _update():
	if not is_node_ready():
		return
	
	_set_label_text()
	icon.texture = requirement.plant_resource.icon

func _process(_delta: float) -> void:
	_set_label_text()

func _set_label_text():
	if not Inventory:
		return
		
	var data = Inventory.plants[requirement.plant_resource];
	label.text = str(data.harvested)+"/"+str(requirement.required_amount)
