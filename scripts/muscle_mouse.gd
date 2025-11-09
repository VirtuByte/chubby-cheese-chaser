extends RigidBody2D

@export var speed = 30
@export var max_distance = 96
@export var player_path: NodePath

var player: Node2D

func _ready() -> void:
	player = get_node(player_path)

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	var direction = to_player.normalized()
	var distance = to_player.length();

	# Raycast to check line of sight
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]  # don't hit yourself
	var result = space.intersect_ray(query)

	var can_see_player = false
	if result.size() == 0:
		# Nothing blocking
		can_see_player = true
	elif result.collider == player:
		# We hit the player first, so it's visible
		can_see_player = true

	# Move only if visible
	if can_see_player and distance < max_distance:
		linear_velocity = direction * speed
		$AnimatedSprite2D.play("walking")
	else:
		linear_velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if GameManager.get_game_started():
		GameManager.trigger_game_over()
