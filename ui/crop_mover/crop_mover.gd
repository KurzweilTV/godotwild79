class_name AnimateCrop
extends Node2D

signal anim_complete

const GLOWROOT = preload("res://crops/resources/glowroot.tres") as Crop
const EMBERBERRY = preload("res://crops/resources/emberberry.tres") as Crop
const DEWBLOSSOM = preload("res://crops/resources/dewblossom.tres") as Crop

var start_position : Vector2
var end_position : Vector2
var crop_texture: Texture2D

func _init(start_loc: Vector2, end_loc: Vector2, crop_type: Crop) -> void:
	start_position = start_loc
	end_position = end_loc

	if crop_type.sprite:
		crop_texture = crop_type.sprite

func _ready() -> void:
	global_position = start_position

	var sprite = Sprite2D.new()
	sprite.texture = crop_texture
	sprite.centered = true
	add_child(sprite)

	var tween = create_tween()
	tween.tween_property(self, "global_position", end_position, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 1.5)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.2).set_delay(1.2)

	tween.finished.connect(_on_anim_finished)

func _on_anim_finished():
	anim_complete.emit()
	queue_free()
