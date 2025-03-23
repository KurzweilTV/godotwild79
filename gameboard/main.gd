extends Node2D

@onready var music: AudioStreamPlayer = %Music
@export var cauldron : Cauldron
@onready var countdown_timer: Control = $GameUI/CountdownTimer
@onready var game_over_screen: Control = $GameUI/GameOverScreen

func _ready() -> void:
	MessageBus.connect("gameover", initiate_gameover)
	cauldron.connect("time_added", add_gametime)
	play_bgm()
	GameManager.reset_score()

func add_gametime(seconds):
	countdown_timer.add_time_to_timer(seconds)

func initiate_gameover():
	game_over_screen.show()

func play_bgm() -> void:
	if Settings.music_enabled:
		music.play()
