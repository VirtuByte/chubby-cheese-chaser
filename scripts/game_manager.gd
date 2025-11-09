extends Node

signal score_changed(new_score: int)

const FINAL_LEVEL_NUMBER = 5

var game_started = false
var score = 0

func start_game():
	game_started = true

func stop_game():
	game_started = false

func get_game_started():
	return game_started

func add_score(value: int) -> void:
	score += value
	emit_signal("score_changed", score)

func get_score() -> int:
	return score

func reset_score() -> void:
	score = 0

func trigger_game_over():
	get_tree().change_scene_to_file("res://levels/game_over.tscn")
