extends Control

@export var next_scene : PackedScene

func load_next_scene() -> void:
	get_tree().change_scene_to_packed(next_scene)
