class_name ToolPlot
extends Plot

@export var tool_name : String
@export var tool_function : String
@export var icon : Texture2D

@onready var tool_icon: Sprite2D = $ToolIcon
@onready var tool_label: Label = $ToolLabel

func _ready() -> void:
	if icon:
		tool_icon.texture = icon
	if tool_function:
		tool_label.text = tool_function

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			handle_tool_pickup_or_drop()

func handle_tool_pickup_or_drop():
	if tool_present and not GlobalCursor.is_holding_tool:
		print("Picked up %s" % tool_name)
		tool_present = false
		GlobalCursor.is_holding_tool = true
		GlobalCursor.set_custom_cursor(icon)
		tool_icon.hide()
	elif not tool_present and GlobalCursor.is_holding_tool:
		print("Put Down %s" % tool_name)
		tool_present = true
		GlobalCursor.is_holding_tool = false
		GlobalCursor.reset_custom_cursor()
		tool_icon.show()
