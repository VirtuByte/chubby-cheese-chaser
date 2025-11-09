extends Node2D

@export var tile_map_layer_walls: TileMapLayer
@export var warp_cheese_location: Vector2 = Vector2(0, 0)

var warp_cheese = preload("res://objects/warp_cheese.tscn")

func _process(_delta: float) -> void:
	var blocks_to_eat = 0
	for cell in tile_map_layer_walls.get_used_cells():
		var current_tile_data = tile_map_layer_walls.get_cell_tile_data(cell)

		if current_tile_data == null || !current_tile_data.get_custom_data("eatable") || current_tile_data.get_custom_data("molded"): continue
		blocks_to_eat += 1

	if blocks_to_eat == 0:
		spawn_warp_cheese()

func spawn_warp_cheese():
	var new_warp_cheese = warp_cheese.instantiate()
	add_child(new_warp_cheese)

	new_warp_cheese.z_index = 1
	new_warp_cheese.position = warp_cheese_location
