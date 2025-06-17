extends Label

func _process(_delta: float) -> void:
	var game_manager = get_tree().get_first_node_in_group("GameManager") as GameManager
	text = "Day " + str(game_manager.current_day)
