extends CharacterBody2D

@export var tile_map_layer_walls: TileMapLayer

const SPEED = 80

var current_direction

enum DIRECTIONS {
	UP,
	UP_RIGHT,
	UP_LEFT,
	DOWN,
	DOWN_RIGHT,
	DOWN_LEFT,
	LEFT,
	RIGHT,
	IDLE,
}

var KEY_UP = false
var KEY_DOWN = false
var KEY_LEFT = false
var KEY_RIGHT = false

func _process(_delta: float) -> void:
	get_input()
	set_direction()
	move()
	
func get_input():
	if Input.is_action_pressed("move_up"): KEY_UP = true
	else: KEY_UP = false
	
	if Input.is_action_pressed("move_down"): KEY_DOWN = true
	else: KEY_DOWN = false
	
	if Input.is_action_pressed("move_left"): KEY_LEFT = true
	else: KEY_LEFT = false
	
	if Input.is_action_pressed("move_right"): KEY_RIGHT = true
	else: KEY_RIGHT = false
	
	if Input.is_action_pressed("dig"):
		var position_in_front = get_position_in_front()

		if tile_map_layer_walls.get_cell_source_id(position_in_front) != -1:
			tile_map_layer_walls.set_cell(position_in_front, -1)
			# tileMapWalls.set_cells_terrain_connect([Vector2(0, 0)], 0, -1, true) # ToDo - Update Autotiling

func set_direction() -> void:
	if KEY_UP:
		if KEY_LEFT: current_direction = DIRECTIONS.UP_LEFT
		elif KEY_RIGHT: current_direction = DIRECTIONS.UP_RIGHT
		else: current_direction = DIRECTIONS.UP

	elif KEY_DOWN:
		if KEY_LEFT: current_direction = DIRECTIONS.DOWN_LEFT
		elif KEY_RIGHT: current_direction = DIRECTIONS.DOWN_RIGHT
		else: current_direction = DIRECTIONS.DOWN

	elif KEY_LEFT: current_direction = DIRECTIONS.LEFT
	elif KEY_RIGHT: current_direction = DIRECTIONS.RIGHT
	else: current_direction = DIRECTIONS.IDLE

func move() -> void:
	match current_direction:
		DIRECTIONS.UP:
			self.velocity = Vector2(0, -SPEED)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(0, -90)
		DIRECTIONS.DOWN:
			self.velocity = Vector2(0, SPEED)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(0, 90)
		DIRECTIONS.LEFT:
			self.velocity = Vector2(-SPEED, 0)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-90, 0)
		DIRECTIONS.RIGHT:
			self.velocity = Vector2(SPEED, 0)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(90, 0)
		DIRECTIONS.UP_LEFT:
			self.velocity = cartesian_to_isometrics(Vector2(-SPEED, 0))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-60, -60)
		DIRECTIONS.UP_RIGHT:
			self.velocity = cartesian_to_isometrics(Vector2(0, -SPEED))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(60, -60)
		DIRECTIONS.DOWN_LEFT:
			self.velocity = cartesian_to_isometrics(Vector2(0, SPEED))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-60, 60)
		DIRECTIONS.DOWN_RIGHT:
			self.velocity = cartesian_to_isometrics(Vector2(SPEED, 0))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(60, 60)
		DIRECTIONS.IDLE:
			self.velocity = Vector2(0, 0)
			$AnimatedSprite2D.stop()

	move_and_slide()

func get_position_in_front() -> Vector2:
	var area = $digDirection/digBox
	var area_global_position = area.global_position
	
	return tile_map_layer_walls.local_to_map(area_global_position)

func cartesian_to_isometrics(cartesian: Vector2) -> Vector2:
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)
