extends Node

signal score_changed(new_score: int)

var score = 0

func _ready() -> void:
	print("NEW")

func add_score(value: int) -> void:
	score += value
	emit_signal("score_changed", score)

func get_score() -> int:
	return score
