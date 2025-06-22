extends Button

@export var active_pannel_state: StyleBox
@export var inactive_pannel_state: StyleBox

var plant: PlantResource

@onready var harvested: Label = $Harvested
var previus_harvested = 0;

@onready var seeds: Label = $Seeds
@onready var plant_icon: TextureRect = $Icon;

@export var click_sound: AudioStream;

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	plant_icon.texture = plant.icon

func _process(_delta: float) -> void:
	if(plant == Events.selected_plant):
		add_theme_stylebox_override("normal", active_pannel_state)
	else:
		add_theme_stylebox_override("normal", inactive_pannel_state)
	
	if (previus_harvested != Inventory.plants[plant].harvested):
		previus_harvested = Inventory.plants[plant].harvested
		
		animation_player.play("pop")
	
	harvested.text = str(Inventory.plants[plant].harvested)
	seeds.text = str(Inventory.plants[plant].seeds) + "/" + str(Inventory.plants[plant].max_seeds)

func _on_pressed() -> void:
	var player = AudioStreamPlayer2D.new();
	player.volume_db = -10;
	player.stream = click_sound;
	get_tree().root.add_child(player)
	player.playing = true
	player.finished.connect(func(): player.queue_free())
	
	if(Events.selected_plant == plant):
		Events.selected_plant = null
	else:
		Events.selected_plant = plant

func _on_info_button_pressed() -> void:
	Events.show_plant(plant)
