extends Node2D

@onready var music: AudioStreamPlayer = %Music


func _ready() -> void:
	play_bgm()

func play_bgm() -> void:
	if Settings.music_enabled:
		music.play()
