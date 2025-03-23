extends Control

@onready var music_slider: HSlider = %MusicSlider
@onready var sound_slider: HSlider = %SoundSlider
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var blur: ColorRect = $Blur
@onready var tutorial_window_4: PanelContainer = $TutorialWindow4
@onready var tutorial_window_3: PanelContainer = $TutorialWindow3
@onready var tutorial_window_2: PanelContainer = $TutorialWindow2
@onready var tutorial_window_1: PanelContainer = $TutorialWindow1

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
		await anims.animation_finished
		blur.show()
		options_open = true
	else:
		anims.play_backwards("options_slide_in")
		blur.hide()
		options_open = false

func _on_opt_close_button_pressed() -> void:
	if options_open:
		anims.play_backwards("options_slide_in")
		options_open = false


func _on_start_button_pressed() -> void:
	anims.play_backwards("fade")
	await anims.animation_finished
	get_tree().change_scene_to_packed(game_scene)


func _on_tutorial_button_pressed() -> void:
	if options_open:
		anims.play_backwards("options_slide_in")
		blur.hide()
		options_open = false
		
	tutorial_window_1.show()
	tutorial_window_2.show()
	tutorial_window_3.show()
	tutorial_window_4.show()


func _on_tut_next_1_pressed() -> void:
	tutorial_window_1.hide()


func _on_tut_next_2_pressed() -> void:
	tutorial_window_2.hide()


func _on_tut_next_3_pressed() -> void:
	tutorial_window_3.hide()


func _on_tut_next_4_pressed() -> void:
	tutorial_window_4.hide()
