extends Node

@export var contents: Dictionary = {}

func add_item(item: String, count: int = 1):
	contents[item] = contents.get(item, 0) + count

func remove_item(item: String, count: int = 1):
	if contents.has(item):
		contents[item] -= count
		if contents[item] <= 0:
			contents.erase(item)

func has_item(item: String, count: int = 1) -> bool:
	return contents.get(item, 0) >= count

func get_item_count(item: String) -> int:
	return contents.get(item, 0)

func print_inventory():
	print("Inventory:", contents)
