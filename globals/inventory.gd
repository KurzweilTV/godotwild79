extends Node # i hate inventories

@warning_ignore("unused_signal")
signal item_added

@export var ui_location: Vector2
@export var contents: Dictionary = {}
@export var debug_inventory : bool = false

func _ready() -> void:
	if debug_inventory:
		add_item("Glowroot", 20)
		add_item("Emberberry", 20)
		add_item("Dewblossom", 20)
		await get_tree().create_timer(.2).timeout
		MessageBus.update_ui.emit()

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
