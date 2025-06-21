extends Button
class_name KnowledgeBookButton

@onready var knowledge_book = $"../KnowledgeBook";

func _on_button_down() -> void:
	knowledge_book.visible = not knowledge_book.visible
