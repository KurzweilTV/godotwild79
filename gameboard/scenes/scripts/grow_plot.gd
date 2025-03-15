class_name Plot 
extends Area2D

var water_art : Sprite2D
var tool_present : bool = true

@export var crop_planted : bool
@export var crop_name : String
@export_category("Water")
@export var watered : bool
@export var water_level : float = 0
@export var water_max : float = 100
@export var water_min : float = 0

@onready var highlight: Sprite2D = $Highlight


func _ready() -> void:
	water_art = get_node_or_null("WaterArt")
	if water_art == null:
		print_debug("WaterArt node not found in ", name)

func _process(delta: float) -> void:
	if water_art:
		var alpha = (water_level - water_min) / (water_max - water_min)
		water_art.self_modulate.a = alpha

	water_level -= 5 * delta

func pick_up_tool() -> void:
	pass
	
func put_down_tool() -> void:
	pass	


func _on_mouse_entered() -> void:
	highlight.show()


func _on_mouse_exited() -> void:
	highlight.hide()
