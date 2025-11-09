extends Control

func _ready() -> void:
	GameManager.stop_game()
	GameManager.reset_score()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		get_tree().change_scene_to_file("res://levels/level_1.tscn")
