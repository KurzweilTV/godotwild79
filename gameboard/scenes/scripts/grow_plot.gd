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
@onready var crop_art: Sprite2D = $CropArt
@onready var no_water_icon: Sprite2D = $NoWater
@onready var till_particles: GPUParticles2D = $TilledIcon/TillParticles
@onready var water_particles: GPUParticles2D = $TilledIcon/WaterParticles
@onready var harvest_particles: GPUParticles2D = $CropArt/HarvestParticles
@onready var leaf_particles: GPUParticles2D = $LeafParticles
@onready var sounds: Node = $Sounds

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
			water_particles.emitting = true
			change_water(100)
			if not %WaterSound.playing:
				%WaterSound.pitch_scale = randf_range(0.9, 1.1)
				%WaterSound.play()
		"Hoe":
			till_ground()
		"Scythe":		
			harvest_crop()
		_:
			_plant_crop(GlobalCursor.held_seed)

func harvest_crop():
	if not ready_to_harvest or not planted_crop:
		return  # Stop if there's nothing to harvest
	
	%HarvestSound.pitch_scale = randf_range(0.8, 1.0)
	%HarvestSound.play()

	var harvest_name := planted_crop.crop_name
	var harvest_amt := planted_crop.harvest_yield
	var crop_anim = AnimateCrop.new(self.global_position, Inventory.ui_location, planted_crop)
	get_tree().current_scene.add_child(crop_anim)
	
	crop_anim.anim_complete.connect(func():
		Inventory.add_item(harvest_name, harvest_amt))

	leaf_particles.emitting = true
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
	crop_art.hide()
	tilled_icon.hide()
	harvest_particles.hide()

func _plant_crop(crop : Crop):
	if ready_to_plant and is_tilled and crop:
		till_particles.emitting = true
		ready_to_plant = false
		crop_planted = true
		planted_crop = crop
		growth_amount = 0.0
		crop_art.scale = Vector2(0.1, 0.1)
		crop_art.texture = crop.sprite
		crop_art.show()
		#GlobalCursor.float_text("%s planted!" % crop.crop_name, Color.DARK_GREEN)

func _handle_plant_growth(delta):
	if not crop_planted or not planted_crop:
		return  # No crop planted
	
	if water_level < planted_crop.water_needed:
		return  # Not enough water to grow
	
	growth_amount += delta / planted_crop.growth_time
	growth_amount = clamp(growth_amount, 0.0, 1.0)

	# Grow crop_art dynamically
	var min_scale = 0.1
	var max_scale = 0.6
	var scale_value = lerp(min_scale, max_scale, growth_amount)
	crop_art.scale = Vector2(scale_value, scale_value)
	
	if growth_amount >= 1.0:
		ready_to_harvest = true
		is_growing = false
	else:
		is_growing = true

	if ready_to_harvest and not harvest_particles.emitting:
		harvest_particles.emitting = true
		harvest_particles.show()
	if not ready_to_harvest and harvest_particles.emitting:
		harvest_particles.emitting = false
		harvest_particles.hide()
		
func animate_crop_ui(start_position: Vector2):
	var moving_icon = AnimateCrop.new(start_position, Inventory.ui_location, planted_crop)
	get_parent().add_child(moving_icon)
		
#region ToolUsage
func till_ground():
	if ready_to_till and not is_tilled:
		tilled_icon.show()
		ready_to_till = false
		is_tilled = true
		ready_to_plant = true
		till_particles.emitting = true
		
		%TillSound.pitch_scale = randf_range(0.7, 0.9)
		%TillSound.play()
		
func change_water(amount: float):
	water_level = clamp(water_level + amount, 0, 100)
	watered = water_level > 0

func _water_drain(delta):
	if water_icon:
		var alpha = (water_level - water_min) / (water_max - water_min)
		water_icon.self_modulate.a = alpha
	change_water(-water_drying_rate * delta)
	if planted_crop and water_level <= planted_crop.water_needed and not ready_to_harvest:
		no_water_icon.show()
	else: no_water_icon.hide()
	
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
