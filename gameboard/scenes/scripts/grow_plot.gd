class_name GrowPlot 
extends Area2D

var water_icon : Sprite2D

@export var crop_planted : bool
@export var crop_name : String
@export_category("Water")
@export var watered : bool
@export var water_level : float = 0
@export var water_max : float = 100
@export var water_min : float = 0
@export var water_can_amount : float = 40
@export var water_drying_rate : int = 5
@export_category("Tilling")
@export var ready_to_till : bool = true
@export var is_tilled : bool = false
@export_category("Planting")
@export var ready_to_plant : bool = false

@onready var tilled_icon: Sprite2D = $TilledIcon
@onready var highlight: Sprite2D = $Highlight

func _ready() -> void:
	water_icon = get_node_or_null("WaterIcon")

func _process(delta: float) -> void:
	_water_drain(delta)

func _handle_tool_usage():
	match GlobalCursor.tool_held:
		"WaterBucket":
			#print("Watering Plot: ", name)
			change_water(water_can_amount)
		"Hoe":
			#print("Tilling Plot: ", name)
			till_ground()
		"Scythe":
			print("Harvesting Plot: ", name)
		_:
			print("Unknown tool used on: ", name)

#region ToolUsage
func till_ground():
	if ready_to_till and not is_tilled:
		tilled_icon.show()
		ready_to_till = false
		is_tilled = true
		ready_to_plant = true
		
func change_water(amount: float):
	water_level = clamp(water_level + amount, 0, 100)
	watered = water_level > 0

func _water_drain(delta):
	if water_icon:
		var alpha = (water_level - water_min) / (water_max - water_min)
		water_icon.self_modulate.a = alpha
	change_water(-water_drying_rate * delta)
	
#region SignalFunctions
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if GlobalCursor.is_holding_tool and event.button_index == MOUSE_BUTTON_LEFT: 
			#print("Clicked ", name, " while holding ", GlobalCursor.tool_held)
			_handle_tool_usage()
			

func _on_mouse_entered() -> void:
	highlight.show()

func _on_mouse_exited() -> void:
	highlight.hide()
#endregion
