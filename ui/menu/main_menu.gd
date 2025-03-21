extends Control

@onready var music_slider: HSlider = %MusicSlider
@onready var sound_slider: HSlider = %SoundSlider
@onready var anims: AnimationPlayer = $AnimationPlayer

@export var game_scene : PackedScene = preload("res://gameboard/Main.tscn")

var options_open : bool = false

func _ready() -> void:
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	music_slider.value_changed.connect(_on_music_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)

func _on_music_slider_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func _on_sound_slider_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED

func _on_options_button_pressed() -> void:
	if not options_open:
		anims.play("options_slide_in")
		options_open = true
	else:
		anims.play_backwards("options_slide_in")
		options_open = false

func _on_opt_close_button_pressed() -> void:
	if options_open:
		anims.play_backwards("options_slide_in")
		options_open = false


func _on_start_button_pressed() -> void:
	anims.play_backwards("fade")
	await anims.animation_finished
	get_tree().change_scene_to_packed(game_scene)
