extends Node2D

const FILE_PREFIX = "res://levels/level_"
const FILE_SUFFIX = ".tscn"
const FINAL_LEVEL_NUMBER = 2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_level"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		if next_level_number > FINAL_LEVEL_NUMBER: return

		var next_level_path = FILE_PREFIX + str(next_level_number) + FILE_SUFFIX
		get_tree().change_scene_to_file(next_level_path)
