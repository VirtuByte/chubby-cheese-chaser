extends Control

func _ready() -> void:
	$score.text = "Your score: " + str(GameManager.get_score())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		get_tree().change_scene_to_file("res://levels/level_0.tscn")
