class_name Crop
extends Resource

@export var crop_name: String
@export var growth_time: float = 10.0  # Time in seconds
@export var water_needed: float = 50.0  # Minimum water required to grow. Might remove?
@export var sprite: Texture2D  # Crop sprite
@export var harvest_yield: int = 1  # How much you get when harvested
