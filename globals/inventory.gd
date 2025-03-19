class_name Cauldron
extends Node2D

@export var current_mixture: Mixture
@onready var liquid: Sprite2D = $Liquid
@onready var ingredient_1: ProgressBar = %Ingredient1
@onready var ingredient_2: ProgressBar = %Ingredient2

const DEWBLOSSOM = preload("res://crops/resources/dewblossom.tres")
const EMBERBERRY = preload("res://crops/resources/emberberry.tres")
const GLOWROOT = preload("res://crops/resources/glowroot.tres")

var cook_slots: Dictionary = {}

func update_liquid_color():
	var total_quantity = 0
	var weighted_color = Color(0, 0, 0, 0)
	
	for slot in cook_slots.values():
		if slot.has("crop") and slot.has("count"):
			var crop: Crop = slot["crop"]
			var count: int = slot["count"]
			if crop and count > 0:
				total_quantity += count
				weighted_color += crop.crop_color * count
	
	if total_quantity > 0:
		weighted_color /= total_quantity
	
	liquid.modulate = weighted_color

func add_ingredient(ingredient: Crop, amount: int) -> void:
	var slot_key = ""
	
	if "ingredient_1" in cook_slots and cook_slots["ingredient_1"].get("crop") == ingredient and cook_slots["ingredient_1"].get("count", 0) < cook_slots["ingredient_1"].get("required", 9999):
		slot_key = "ingredient_1"
	elif "ingredient_2" in cook_slots and cook_slots["ingredient_2"].get("crop") == ingredient and cook_slots["ingredient_2"].get("count", 0) < cook_slots["ingredient_2"].get("required", 9999):
		slot_key = "ingredient_2"
	elif "ingredient_1" not in cook_slots:
		slot_key = "ingredient_1"
	elif "ingredient_2" not in cook_slots:
		slot_key = "ingredient_2"
	else:
		GlobalCursor.float_text("Cauldron is full", Color.RED)
		return

	if Inventory.has_item(ingredient.crop_name, amount):
		Inventory.remove_item(ingredient.crop_name, amount)
		
		if slot_key not in cook_slots:
			cook_slots[slot_key] = {"crop": ingredient, "count": amount, "required": current_mixture.inveredient_1_amount if slot_key == "ingredient_1" else current_mixture.inveredient_2_amount}
		else:
			cook_slots[slot_key]["count"] += amount
		
		update_liquid_color()
		update_progress_ui()
	else:
		GlobalCursor.float_text("Not Enough\n%s" % ingredient.crop_name, Color.RED)

func update_progress_ui():
	if "ingredient_1" in cook_slots:
		ingredient_1.value = cook_slots["ingredient_1"].get("count", 0)
		ingredient_1.max_value = cook_slots["ingredient_1"].get("required", 0)
	if "ingredient_2" in cook_slots:
		ingredient_2.value = cook_slots["ingredient_2"].get("count", 0)
		ingredient_2.max_value = cook_slots["ingredient_2"].get("required", 0)

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
