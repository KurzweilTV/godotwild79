extends PanelContainer


@onready var inventory_particle: GPUParticles2D = $MarginContainer/VBoxContainer/Title/InventoryParticle
@onready var green_count: Label = %GreenCount
@onready var red_count: Label = %RedCount
@onready var blue_count: Label = %BlueCount

func _ready() -> void:
	MessageBus.update_ui.connect(_update_ui)
	Inventory.ui_location = global_position
	Inventory.item_added.connect(animate_ui)
	
func animate_ui() -> void:
	var new_particles = inventory_particle.duplicate()  # Duplicate the existing particles
	get_tree().current_scene.add_child(new_particles)  # Add to the scene
	new_particles.global_position = inventory_particle.global_position  # Set the same position
	new_particles.emitting = true  # Start emitting
	await get_tree().create_timer(new_particles.lifetime).timeout
	new_particles.queue_free()

	
func _update_ui() -> void: 
	green_count.text = str(Inventory.contents.get("Glowroot", 0))
	red_count.text = str(Inventory.contents.get("Emberberry", 0))
	blue_count.text = str(Inventory.contents.get("Dewblossom", 0))
