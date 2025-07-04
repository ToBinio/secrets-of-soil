extends Node3D
class_name Plant

@export var plant: PlantResource
@export var clicker_area: ClickerArea
@export var removal_particles: PackedScene

func _ready() -> void:
	clicker_area.on_click.connect(_on_click)
	
func _on_click():
	Inventory.plants[plant].harvested += 1
	GameManager.instant(self).stats.plants_harvested += 1
	
	var stream = load("res://assets/music/destroy.wav")
	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.volume_db = -10
	get_tree().root.add_child(player)
	player.play()
	player.finished.connect(func(): player.queue_free())
	
	queue_free()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		var particles = removal_particles.instantiate()
		if get_parent() && is_inside_tree():
			get_parent().add_child(particles)
			particles.global_position = global_position
