extends Node

var player_score : int

func add_points(count):
	player_score += count

func reset_score() -> bool:
	player_score = 0
	return true
