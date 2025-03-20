extends Node2D

signal new_order(order: Mixture)

const BLAZEBLOOM = preload("res://mixtures/blazebloom.tres")
const DISTILLED_DEWBERRY = preload("res://mixtures/distilled_dewberry.tres")
const DISTILLED_EMBERBERRY = preload("res://mixtures/distilled_emberberry.tres")
const DISTILLED_GLOWROOT = preload("res://mixtures/distilled_glowroot.tres")
const GLOWDEW = preload("res://mixtures/glowdew.tres")
const STEAM_TONIC = preload("res://mixtures/steam_tonic.tres")

@onready var order_icon: TextureRect = %OrderIcon
@onready var next_order_icon: TextureRect = $NextOrderUI/PanelContainer/MarginContainer/NextOrderIcon

@export var current_order : Mixture = DISTILLED_GLOWROOT
@export var next_order : Mixture = BLAZEBLOOM

var mixture_list : Array[Mixture] = [
	GLOWDEW, 
	BLAZEBLOOM, 
	STEAM_TONIC,
	DISTILLED_DEWBERRY,
	DISTILLED_EMBERBERRY,
	DISTILLED_GLOWROOT,
	]
	
var upcoming_orders : Array

func _ready() -> void:
	randomize()
	await get_tree().create_timer(.2).timeout
	add_order(current_order)

func _process(_delta: float) -> void:
	update_order_icon()

func add_order(order: Mixture):
	current_order = order
	new_order.emit(current_order)
	update_order_icon()

func update_order_icon():
	order_icon.texture = current_order.mixture_icon
	next_order_icon.texture = next_order.mixture_icon

func cycle_in_next_order():
	current_order = null
	add_order(next_order)
	next_order = mixture_list.pick_random()
