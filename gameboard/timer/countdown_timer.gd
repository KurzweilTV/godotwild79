extends Control

@onready var time_label: Label = %TimeLabel
@onready var game_timer: Timer = $GameTimer

func _process(delta: float) -> void:
	time_label.text = str(int(game_timer.time_left))

func _on_game_timer_timeout() -> void:
	print("Gameover")
	MessageBus.gameover.emit()
