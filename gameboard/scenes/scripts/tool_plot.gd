class_name ToolPlot
extends Area2D

var tool_present : bool = true

@export var tool_name : String
@export var tool_function : String
@export var icon : Texture2D
@export_category("Seed")
@export var is_seed : bool
@export var crop : Crop

@onready var tool_icon: Sprite2D = $ToolIcon
@onready var tool_label: Label = $ToolLabel
@onready var highlight: Sprite2D = $Highlight

func _ready() -> void:
	if icon:
		tool_icon.texture = icon
	if tool_function:
		tool_label.text = tool_function

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT: 
			handle_tool_pickup_or_drop()

func handle_tool_pickup_or_drop():
	if tool_present and not GlobalCursor.is_holding_tool:
		# Pick up the tool
		tool_present = false
		GlobalCursor.is_holding_tool = true
		GlobalCursor.held_seed = crop
		GlobalCursor.tool_held = tool_name
		GlobalCursor.tool_source = self  # Store original tool location
		GlobalCursor.set_custom_cursor(icon)
		tool_icon.hide()

	elif GlobalCursor.is_holding_tool:
		# If holding a tool and clicking on its original spot, return it manually
		if GlobalCursor.tool_source == self:
			return_tool()
			GlobalCursor.is_holding_tool = false
			GlobalCursor.tool_source = null
			GlobalCursor.reset_custom_cursor()
		
		# If holding a different tool, swap them
		elif GlobalCursor.tool_source and GlobalCursor.tool_source != self:
			# Return the previously held tool to its original spot
			GlobalCursor.tool_source.return_tool()
			
			# Pick up the new tool
			tool_present = false
			GlobalCursor.is_holding_tool = true
			GlobalCursor.tool_source = self  # Update tool source
			GlobalCursor.tool_held = tool_name
			GlobalCursor.held_seed = crop
			GlobalCursor.set_custom_cursor(icon)
			tool_icon.hide()

# Function to return the tool to its original ToolPlot
func return_tool():
	tool_present = true
	tool_icon.show()

func _on_mouse_entered() -> void:
	highlight.show()


func _on_mouse_exited() -> void:
	highlight.hide()
