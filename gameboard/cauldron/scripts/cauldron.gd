class_name Cauldron
extends Node2D

@export var cook_slot_1: Dictionary = {} # Glowroot
@export var cook_slot_2: Dictionary = {} # Emberberry
@export var cook_slot_3: Dictionary = {} # Dewblossom

const DEWBLOSSOM = preload("res://crops/resources/dewblossom.tres") # Blue
const EMBERBERRY = preload("res://crops/resources/emberberry.tres") # Red
const GLOWROOT = preload("res://crops/resources/glowroot.tres") # Green

@onready var ingredient_1: ProgressBar = %Ingredient1
@onready var ingredient_2: ProgressBar = %Ingredient2
@onready var ingredient_3: ProgressBar = %Ingredient3

@onready var liquid: Sprite2D = $Liquid

func update_liquid_color():
	var total_quantity = 0
	var weighted_color = Color(0, 0, 0, 0)

	var ingredient_slots = [cook_slot_1, cook_slot_2, cook_slot_3]
	
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


func add_ingredient(slot: Dictionary, ingredient: Crop, amount: int) -> void:
	var ingredient_name = ingredient.crop_name

	if Inventory.has_item(ingredient_name, amount):
		Inventory.remove_item(ingredient_name, amount)

		if slot.has("crop") and slot["crop"] == ingredient:
			slot["count"] += amount
		else:
			slot["crop"] = ingredient
			slot["count"] = amount

		update_liquid_color()
		update_progress_ui()
		
	else:
		GlobalCursor.float_text("Not enough!", Color.RED)
		print("Not enough ", ingredient_name, " in inventory")

func update_progress_ui():
	ingredient_1.value = cook_slot_1.get("count", 0)
	ingredient_2.value = cook_slot_2.get("count", 0)
	ingredient_3.value = cook_slot_3.get("count", 0)
	
# Buttons
func _on_add_glowroot_one_pressed() -> void:
	add_ingredient(cook_slot_1, GLOWROOT, 1)

func _on_add_glowroot_five_pressed() -> void:
	add_ingredient(cook_slot_1, GLOWROOT, 5)

func _on_add_emberberry_one_pressed() -> void:
	add_ingredient(cook_slot_2, EMBERBERRY, 1)

func _on_add_emberberry_five_pressed() -> void:
	add_ingredient(cook_slot_2, EMBERBERRY, 5)

func _on_add_dewblossom_one_pressed() -> void:
	add_ingredient(cook_slot_3, DEWBLOSSOM, 1)

func _on_add_dewblossom_five_pressed() -> void:
	add_ingredient(cook_slot_3, DEWBLOSSOM, 5)
