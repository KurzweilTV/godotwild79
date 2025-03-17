extends PanelContainer

@onready var green_count: Label = %GreenCount
@onready var red_count: Label = %RedCount
@onready var blue_count: Label = %BlueCount

func _ready() -> void:
	MessageBus.update_ui.connect(_update_ui)
	
func _update_ui() -> void: 
	green_count.text = str(Inventory.contents.get("Glowroot", 0))
	red_count.text = str(Inventory.contents.get("Emberberry", 0))
	blue_count.text = str(Inventory.contents.get("Dewblossom", 0))
