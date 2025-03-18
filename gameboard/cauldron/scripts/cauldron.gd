class_name Cauldron
extends Node2D

@export var cook_slot_1: Dictionary = {}
@export var cook_slot_2: Dictionary = {} 

const DEWBLOSSOM = preload("res://crops/resources/dewblossom.tres") # Blue
const EMBERBERRY = preload("res://crops/resources/emberberry.tres") # Red
const GLOWROOT = preload("res://crops/resources/glowroot.tres") # Green

@onready var liquid: Sprite2D = $Liquid

func update_liquid_color():
	var total_quantity = 0
	var weighted_color = Color(0, 0, 0, 0)

	# List of active ingredient slots
	var ingredient_slots = [cook_slot_1, cook_slot_2]
	
	for slot in ingredient_slots:
		if slot and slot.has("crop") and slot.has("count"):
			var crop: Crop = slot["crop"]
			var count: int = slot["count"]

			if crop and count > 0:
				total_quantity += count
				weighted_color += crop.crop_color * count

	if total_quantity > 0:
		weighted_color /= total_quantity 

	liquid.modulate = weighted_color


func add_ingredient(ingredient: Crop, amount: int) -> void:
	var ingredient_name = ingredient.crop_name

	if Inventory.has_item(ingredient_name, amount):
		Inventory.remove_item(ingredient_name, amount)

		var slots = [cook_slot_1, cook_slot_2]

		for i in range(slots.size()):
			if slots[i].has("crop") and slots[i]["crop"] == ingredient:
				slots[i]["count"] += amount
				update_liquid_color()
				return

		for i in range(slots.size()):
			if slots[i].is_empty():
				slots[i]["crop"] = ingredient
				slots[i]["count"] = amount
				update_liquid_color()
				return
	else:
		GlobalCursor.float_text("Not enough!", Color.RED)
		print("Not enough ", ingredient_name, " in inventory")

# BUTTON FUNCTIONS
func _on_add_glowroot_one_pressed() -> void:
	add_ingredient(GLOWROOT, 1)

func _on_add_glowroot_five_pressed() -> void:
	add_ingredient(GLOWROOT, 5)

func _on_add_emberberry_one_pressed() -> void:
	add_ingredient(EMBERBERRY, 1)

func _on_add_emberberry_five_pressed() -> void:
	add_ingredient(EMBERBERRY, 5)

func _on_add_dewblossom_one_pressed() -> void:
	add_ingredient(DEWBLOSSOM, 1)

func _on_add_dewblossom_five_pressed() -> void:
	add_ingredient(DEWBLOSSOM, 5)
