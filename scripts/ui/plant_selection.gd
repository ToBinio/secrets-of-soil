extends Button

@export var active_pannel_state: StyleBox
@export var inactive_pannel_state: StyleBox

var plant: PlantResource

@onready var name_label: Label = $Name
@onready var count: Label = $Count

func _ready() -> void:
	name_label.text = plant.name

func _process(_delta: float) -> void:
	if(plant == Events.selected_plant):
		add_theme_stylebox_override("normal", active_pannel_state)
	else:
		add_theme_stylebox_override("normal", inactive_pannel_state)
	
	count.text = str(Inventory.plants[plant])

func _on_pressed() -> void:
	Events.selected_plant = plant

func _on_info_button_pressed() -> void:
	Events.show_plant(plant)
