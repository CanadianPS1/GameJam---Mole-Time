extends Node2D

# different states bird can be in
enum BirdState {
	CIRCLING,
	POSITIONING,  # moving above player
	WAITING,      # hovering above player
	SWOOPING,     # diving down at player
	RETURNING     # returning to it's spawn location
}

var player: CharacterBody2D
var current_state: BirdState = BirdState.CIRCLING
var speed = 100
var hover_height = 75
var wait_timer: Timer
var homePos: Vector2

func _ready():
	player = get_node("../Player")
	
	homePos = global_position
	
	wait_timer = Timer.new()
	wait_timer.wait_time = 1.0
	wait_timer.one_shot = true # makes timer only happen once
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	add_child(wait_timer)
	
	if has_node("DetectionField"):
		$DetectionField.body_entered.connect(_on_detection_radius_body_entered)
		
	if has_node("Hitbox"):
		$Hitbox.body_entered.connect(_on_hit_box_body_entered)

func _process(delta):
	
	# if the player starts digging, the bird will return home
	if player.isDigging and current_state != BirdState.RETURNING:
		current_state = BirdState.RETURNING
	
	if(!player.isDigging or current_state == BirdState.RETURNING):
		match current_state:
			BirdState.CIRCLING:
				circle_behavior(delta)
			BirdState.POSITIONING:
				position_above_plr(delta)
			BirdState.WAITING:
				hover_behavior(delta)
			BirdState.SWOOPING:
				swoop_behavior(delta)
			BirdState.RETURNING:
				return_behavior(delta)

func _on_wait_timer_timeout():
	current_state = BirdState.SWOOPING

func circle_behavior(delta):
	var targetPos = Vector2(player.global_position.x, player.global_position.y - hover_height)
	var direction = (targetPos - global_position).normalized()
	global_position += direction * (speed * 0.5) * delta
	
	flip_sprite(direction)
	
func position_above_plr(delta):
	var targetPos = Vector2(player.global_position.x, player.global_position.y - hover_height)
	var direction = (targetPos - global_position).normalized()
	global_position += direction *speed * delta
	
	flip_sprite(direction)
	
	if global_position.distance_to(targetPos) < 15:
		current_state = BirdState.WAITING
		wait_timer.start()  # Start the 1-second swoop timer
		

func hover_behavior(delta):
	var hover_target = Vector2(player.global_position.x, player.global_position.y - hover_height)
	var direction = (hover_target - global_position).normalized()
	global_position += direction * (speed * 0.3) * delta
	
func swoop_behavior(delta):
	# Dive straight down at the player
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	
	flip_sprite(direction)
	
	# Check if swoop is complete (past player or hit ground)
	if global_position.y >= player.global_position.y - 10:
		reset_to_circling()

func return_behavior(delta):
	var direction = (homePos - global_position).normalized()
	global_position += direction
	
	flip_sprite(direction)
	
	if global_position.distance_to(homePos) < 10:
		global_position = homePos
		current_state = BirdState.CIRCLING
	
		
func flip_sprite(direction: Vector2):
	if has_node("AnimatedSprite2D"):
		if direction.x >= 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

func start_swoop_attack():
	# Call this to trigger the swoop sequence
	if current_state == BirdState.CIRCLING:
		current_state = BirdState.POSITIONING

func reset_to_circling():
	current_state = BirdState.CIRCLING

func _on_detection_radius_body_entered(delta):
	start_swoop_attack()

func _on_hit_box_body_entered(body):
	if body.has_method("kill_player"):
		body.kill_player()
