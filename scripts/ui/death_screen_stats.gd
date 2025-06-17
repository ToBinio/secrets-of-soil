extends GridContainer

@onready var plants_harvested: Label = $Panel/PanelContainer/Header2
@onready var new_knowledge: Label = $Panel2/PanelContainer/Header2
@onready var days_survived: Label = $Panel3/PanelContainer/Header2
@onready var food_consumed: Label = $Panel4/PanelContainer/Header2
@onready var killed_by_village: Label = $Panel5/PanelContainer/Header2
@onready var quests_completed: Label = $Panel6/PanelContainer/Header2

func _process(_delta: float) -> void:
	if(is_visible_in_tree()):
		return
	
	var game_manager = GameManager.instant(self)
	
	plants_harvested.text = str(game_manager.stats.plants_harvested)
	new_knowledge.text = str(game_manager.stats.knowledge_gathered)
	days_survived.text = str(game_manager.stats.days_survived)
	food_consumed.text = str(game_manager.stats.food_consumed)
	killed_by_village.text = str(game_manager.stats.plants_destroyed_by_village)
	quests_completed.text = str(game_manager.stats.quests_completed)
