extends CharacterBody2D

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

signal score_changed(new_score: int)

@export var tile_map_layer_walls: TileMapLayer
@export var speed = 80
@export var tile_set_id = 3

@onready var tile_replace_timer = $TileReplaceTimer

#Eating Sounds
@onready var eat_sound_mouse = $EatSoundMouse
@onready var eat_sound_cooldown = $EatSoundCooldown
var can_play_eat_sound = true

var current_direction: DIRECTIONS
var score = 0

func _ready() -> void:
	
	eat_sound_cooldown.wait_time = 0.3
	score = 0
	tile_replace_timer.wait_time = 0.10

func _process(_delta: float) -> void:	
	if !Input.is_action_pressed("move"):
		current_direction = DIRECTIONS.IDLE

	move()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion || event is InputEventMouseButton:
		var mouse_angle = rad_to_deg(get_angle_to(get_global_mouse_position()))
		set_direction(mouse_angle)

func set_direction(mouse_angle: float) -> void:
	if mouse_angle <= -157.5 || mouse_angle >= 157.5:
		current_direction = DIRECTIONS.LEFT
	elif mouse_angle <= -112.5 && mouse_angle > -157.5:
		current_direction = DIRECTIONS.UP_LEFT
	elif mouse_angle <= -67.5 && mouse_angle > -112.5:
		current_direction = DIRECTIONS.UP
	elif mouse_angle <= -22.5 && mouse_angle > -67.5:
		current_direction = DIRECTIONS.UP_RIGHT
	elif mouse_angle <= 22.5 && mouse_angle > -22.5:
		current_direction = DIRECTIONS.RIGHT
	elif mouse_angle <= 67.5 && mouse_angle > 22.5:
		current_direction = DIRECTIONS.DOWN_RIGHT
	elif mouse_angle <= 112.5 && mouse_angle > 67.5:
		current_direction = DIRECTIONS.DOWN
	elif mouse_angle <= 157.5 && mouse_angle > 112.5:
		current_direction = DIRECTIONS.DOWN_LEFT

func move() -> void:
	match current_direction:
		DIRECTIONS.UP:
			self.velocity = Vector2(0, -speed)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(0, -18)
		DIRECTIONS.DOWN:
			self.velocity = Vector2(0, speed)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(0, 12)
		DIRECTIONS.LEFT:
			self.velocity = Vector2(-speed, 0)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-22, -3)
		DIRECTIONS.RIGHT:
			self.velocity = Vector2(speed, 0)
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(22, -3)
		DIRECTIONS.UP_LEFT:
			self.velocity = cartesian_to_isometrics(Vector2(-speed, 0))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-12, -12)
		DIRECTIONS.UP_RIGHT:
			self.velocity = cartesian_to_isometrics(Vector2(0, -speed))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(12, -12)
		DIRECTIONS.DOWN_LEFT:
			self.velocity = cartesian_to_isometrics(Vector2(0, speed))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(-12, 5)
		DIRECTIONS.DOWN_RIGHT:
			self.velocity = cartesian_to_isometrics(Vector2(speed, 0))
			$AnimatedSprite2D.play("walking")
			$digDirection.position = Vector2(12, 5)
		DIRECTIONS.IDLE:
			self.velocity = Vector2(0, 0)
			$AnimatedSprite2D.stop()

	move_and_slide()

func add_score(amount: int) -> void:
	score = max(0, score + amount)
	emit_signal("score_changed", score)
	

func play_eating_sound():
	if can_play_eat_sound:
		eat_sound_mouse.play()
		can_play_eat_sound = false
		eat_sound_cooldown.start()

func eat() -> void:
	var position_in_front = get_position_in_front()

	if tile_map_layer_walls.get_cell_source_id(position_in_front) != -1:
		if tile_map_layer_walls.get_cell_tile_data(position_in_front).get_custom_data("eatable"):
			var eat_state: int = tile_map_layer_walls.get_cell_tile_data(position_in_front).get_custom_data("eat_state")
			
			if tile_map_layer_walls.get_cell_tile_data(position_in_front).get_custom_data("molded"):
				add_score(-30)
				

			if eat_state <= 2:
				tile_map_layer_walls.set_cell(position_in_front, tile_set_id, Vector2(eat_state + 4, 0))
			else:
				tile_map_layer_walls.set_cell(position_in_front, -1)
				# tileMapWalls.set_cells_terrain_connect([Vector2(0, 0)], 0, -1, true) # ToDo - Update Autotiling
				add_score(10)
			play_eating_sound()

func get_position_in_front() -> Vector2:
	var area = $digDirection/digBox
	var area_global_position = area.global_position
	
	return tile_map_layer_walls.local_to_map(area_global_position)

func cartesian_to_isometrics(cartesian: Vector2) -> Vector2:
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _on_dig_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("tiles"):
		tile_replace_timer.start()

func _on_dig_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("tiles"):
		tile_replace_timer.stop()

func _on_tile_replace_timer_timeout() -> void:
	if $digDirection/digBox.get_overlapping_bodies().size() > 0:
		for area in $digDirection/digBox.get_overlapping_bodies():
			if area.is_in_group("tiles"):
				eat()

func _on_score_label_score_signal() -> void:
	pass # Replace with function body.


func _on_eat_sound_cooldown_timeout() -> void:
	can_play_eat_sound = true
