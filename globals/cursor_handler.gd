extends Node

var is_holding_tool : bool
var tool_held : String
var held_seed : Crop

func set_custom_cursor(icon: Texture2D):
	Input.set_custom_mouse_cursor(icon, Input.CURSOR_ARROW, icon.get_size() / 2)

func reset_custom_cursor():
	Input.set_custom_mouse_cursor(null)

func float_text(text: String, color: Color):
	var floating_text_scene = preload("res://globals/FloatingText.tscn")  # Load your FloatingText scene
	var floating_text = floating_text_scene.instantiate()
	
	get_tree().root.add_child(floating_text)  # Add to the scene
	floating_text.global_position = get_viewport().get_mouse_position()
	floating_text.setup(text, color)  # Pass text and color
