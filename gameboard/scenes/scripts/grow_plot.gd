class_name GrowPlot 
extends Area2D

var water_icon : Sprite2D
var is_growing : bool
var growth_amount : float

@export var crop_planted : bool
@export var crop_name : String
@export_category("Water")
@export var watered : bool
@export var water_level : float = 0
@export var water_max : float = 100
@export var water_min : float = 0
@export var water_drying_rate : int = 7
@export_category("Tilling")
@export var ready_to_till : bool = true
@export var is_tilled : bool = false
@export_category("Planting")
@export var ready_to_plant : bool = false
@export var planted_crop : Crop
@export_category("Harvesting")
@export var ready_to_harvest : bool = false

@onready var tilled_icon: Sprite2D = $TilledIcon
@onready var highlight: Sprite2D = $Highlight

var is_mouse_over: bool = false

func _ready() -> void:
	water_icon = get_node_or_null("WaterIcon")

func _process(delta: float) -> void:
	_water_drain(delta)
	_handle_plant_growth(delta)
	
	# allow player to just sweep the mouse
	if is_mouse_over and GlobalCursor.is_holding_tool and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_handle_tool_usage()

func _handle_tool_usage():
	match GlobalCursor.tool_held:
		"WaterBucket":
			change_water(100)
		"Hoe":
			till_ground()
		"Scythe":		
			harvest_crop()
		_:
			_plant_crop(GlobalCursor.held_seed)

func harvest_crop():
	#print("Harvesting Plot: ", name)

	if not ready_to_harvest:
		return

	crop_planted = false
	crop_name = ""
	planted_crop = null
	ready_to_harvest = false
	is_growing = false
	watered = false
	ready_to_plant = false
	is_tilled = false
	ready_to_till = true
	water_level = 0
	growth_amount = 0.0
	tilled_icon.hide()

func _plant_crop(crop : Crop):
	if ready_to_plant and is_tilled:
		#print("Planting: ", crop.crop_name)
		ready_to_plant = false
		crop_planted = true
		planted_crop = crop

func _handle_plant_growth(delta):
	if not crop_planted or not planted_crop:
		return  # No crop planted, exit early
	
	if water_level < planted_crop.water_needed:
		return  # Not enough water to grow
	
	growth_amount += delta / planted_crop.growth_time
	growth_amount = clamp(growth_amount, 0.0, 1.0)
	
	if growth_amount >= 1.0:
		ready_to_harvest = true
		is_growing = false
	else:
		is_growing = true

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
			_handle_tool_usage()

func _on_mouse_entered() -> void:
	highlight.show()
	is_mouse_over = true

func _on_mouse_exited() -> void:
	highlight.hide()
	is_mouse_over = false
#endregion
