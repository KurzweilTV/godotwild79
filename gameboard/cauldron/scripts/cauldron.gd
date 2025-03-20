class_name Cauldron
extends Node2D

@export var current_mixture: Mixture = preload("res://mixtures/blazebloom.tres")
@onready var liquid: Sprite2D = $Liquid
@onready var ingredient_1_bar: ProgressBar = %Ingredient1
@onready var ingredient_2_bar: ProgressBar = %Ingredient2
@onready var texture_1: TextureRect = %Texture1
@onready var texture_2: TextureRect = %Texture2
@onready var order_scene: Node2D = $OrderScene

const DEWBLOSSOM = preload("res://crops/resources/dewblossom.tres")
const EMBERBERRY = preload("res://crops/resources/emberberry.tres")
const GLOWROOT = preload("res://crops/resources/glowroot.tres")

var cook_slots: Dictionary = {}

func _ready() -> void:
	order_scene.connect("new_order", Callable(self, "set_order"))

func _process(_delta: float) -> void: #HACK this is ugly and lazy as fuck
	if current_mixture:
		texture_1.texture = current_mixture.ingredient_1.sprite
		texture_2.texture = current_mixture.ingredient_2.sprite

func set_order(order: Mixture):
	print("New order: ", order.mixture_name)
	current_mixture = order

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
	var slot_keys = []
	
	if current_mixture:
		if ingredient == current_mixture.ingredient_1:
			slot_keys.append("ingredient_1")
		if ingredient == current_mixture.ingredient_2:
			slot_keys.append("ingredient_2")
		
		if slot_keys.is_empty():
			GlobalCursor.float_text("Invalid\ningredient", Color.RED)
			return
	
	# Ensure both slots exist
	if "ingredient_1" in slot_keys and "ingredient_2" in slot_keys and current_mixture.ingredient_1 == current_mixture.ingredient_2:
		slot_keys = ["ingredient_1", "ingredient_2"]

	# Track how much is left to add
	var remaining_amount = amount

	# Try to add to each slot in order
	for slot_key in slot_keys:
		if slot_key in cook_slots and cook_slots[slot_key].get("count", 0) >= cook_slots[slot_key].get("required", 9999):
			continue  # Skip full slots

		var required_amount = current_mixture.ingredient_1_amount if slot_key == "ingredient_1" else current_mixture.ingredient_2_amount
		var current_amount = cook_slots.get(slot_key, {}).get("count", 0)
		var addable_amount = min(remaining_amount, required_amount - current_amount)

		if addable_amount > 0:
			if Inventory.has_item(ingredient.crop_name, addable_amount):
				Inventory.remove_item(ingredient.crop_name, addable_amount)
				
				if slot_key not in cook_slots:
					cook_slots[slot_key] = {
						"crop": ingredient,
						"count": addable_amount,
						"required": required_amount
					}
				else:
					cook_slots[slot_key]["count"] += addable_amount
				
				remaining_amount -= addable_amount

	# If nothing was added, show an error
	if remaining_amount == amount:
		GlobalCursor.float_text("Ingredient slot is full", Color.RED)

	# Update UI if something was added
	if amount != remaining_amount:
		update_liquid_color()
		update_progress_ui()

func update_progress_ui():
	if "ingredient_1" in cook_slots:
		var ing1_data = cook_slots["ingredient_1"]
		ingredient_1_bar.value = ing1_data.get("count", 0)
		ingredient_1_bar.max_value = ing1_data.get("required", 0)

		var stylebox = ingredient_1_bar.get_theme_stylebox("fill").duplicate()
		stylebox.bg_color = ing1_data["crop"].crop_color
		ingredient_1_bar.add_theme_stylebox_override("fill", stylebox)
	
	if "ingredient_2" in cook_slots:
		var ing2_data = cook_slots["ingredient_2"]
		ingredient_2_bar.value = ing2_data.get("count", 0)
		ingredient_2_bar.max_value = ing2_data.get("required", 0)

		var stylebox = ingredient_2_bar.get_theme_stylebox("fill").duplicate()
		stylebox.bg_color = ing2_data["crop"].crop_color
		ingredient_2_bar.add_theme_stylebox_override("fill", stylebox)

func reset_cauldron():
	cook_slots.clear()
	liquid.modulate = Color(1, 1, 1, 1)  # Reset color to default
	ingredient_1_bar.value = 0
	ingredient_2_bar.value = 0
	texture_1.texture = null
	texture_2.texture = null

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

func _on_mix_button_pressed() -> void:
	if not current_mixture:
		GlobalCursor.float_text("No recipe", Color.RED) # this shouldn't happen
		return

	var ing1_filled = "ingredient_1" in cook_slots and cook_slots["ingredient_1"].get("count", 0) >= cook_slots["ingredient_1"].get("required", 0)
	var ing2_filled = "ingredient_2" in cook_slots and cook_slots["ingredient_2"].get("count", 0) >= cook_slots["ingredient_2"].get("required", 0)

	if ing1_filled and ing2_filled:
		print("Mixing %s" % current_mixture.mixture_name)
		reset_cauldron()
		order_scene.cycle_in_next_order()
	else:
		GlobalCursor.float_text("Ingredients\nmissing!", Color.RED)
