extends Control

@onready var score_label: Label = $PanelContainer/VBoxContainer/HBoxContainer/ScoreLabel

func _process(_delta: float) -> void:
	score_label.text = str(GameManager.player_score)


func _on_button_pressed() -> void:
	GameManager.reset_score()
	get_tree().reload_current_scene()
