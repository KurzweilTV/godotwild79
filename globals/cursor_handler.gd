extends Node

var is_holding_tool : bool
var tool_held : String
var held_seed : Crop

func set_custom_cursor(icon: Texture2D):
	Input.set_custom_mouse_cursor(icon, Input.CURSOR_ARROW, icon.get_size() / 2)

func reset_custom_cursor():
	Input.set_custom_mouse_cursor(null)
