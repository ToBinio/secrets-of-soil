extends Button

@export var active_pannel_state: StyleBox
@export var inactive_pannel_state: StyleBox

var plant: PlantResource

@onready var name_label: Label = $Name
@onready var harvested: Label = $Harvested
@onready var seeds: Label = $Seeds
@onready var plant_icon: TextureRect = $Icon;

func _ready() -> void:
	name_label.text = plant.name
	plant_icon.texture = plant.icon

func _process(_delta: float) -> void:
	if(plant == Events.selected_plant):
		add_theme_stylebox_override("normal", active_pannel_state)
	else:
		add_theme_stylebox_override("normal", inactive_pannel_state)
	
	harvested.text = "Harvested:" + str(Inventory.plants[plant].harvested)
	seeds.text = "Seeds:" + str(Inventory.plants[plant].seeds) + "/" + str(Inventory.plants[plant].max_seeds)

func _on_pressed() -> void:
	if(Events.selected_plant == plant):
		Events.selected_plant = null
	else:
		Events.selected_plant = plant

func _on_info_button_pressed() -> void:
	Events.show_plant(plant)
