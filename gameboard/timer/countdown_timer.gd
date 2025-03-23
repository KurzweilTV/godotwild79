extends Control

@onready var time_label: Label = %TimeLabel
@onready var game_timer: Timer = $GameTimer

func _process(_delta: float) -> void:
	time_label.text = str(int(game_timer.time_left))
	set_timer_color()

func set_timer_color():
	if game_timer.time_left < 10:
		time_label.modulate = Color.RED
	else: time_label.modulate = Color.WHITE

func _on_game_timer_timeout() -> void:
	print("Gameover")
	MessageBus.gameover.emit()
