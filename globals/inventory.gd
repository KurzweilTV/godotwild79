extends Node

signal item_added

@export var ui_location: Vector2
@export var contents: Dictionary = {}

func add_item(item: String, count: int = 1):
	contents[item] = contents.get(item, 0) + count
	MessageBus.update_ui.emit()
	Inventory.item_added.emit()

func remove_item(item: String, count: int = 1):
	if contents.has(item):
		contents[item] -= count
		if contents[item] <= 0:
			contents.erase(item)
	MessageBus.update_ui.emit()

func has_item(item: String, count: int = 1) -> bool:
	return contents.get(item, 0) >= count

func get_item_count(item: String) -> int:
	return contents.get(item, 0)

func print_inventory():
	print("Inventory:", contents)
