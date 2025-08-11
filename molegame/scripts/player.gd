extends CharacterBody2D

var jump_velocity = -500.0
var speed = 200.0
var numWorms = 0
var isDigging = true
var wormTimer: Timer
var v = 0
var isDead: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var rigid_body: RigidBody2D = $CollisionShape2D/RigidBody2D
@onready var color_rect: ColorRect = $Camera2D/ColorRect



func _process(delta):
	if not isDigging:
		color_rect.visible = true
	else:
		color_rect.visible = false
	
func _ready():
	#creates worm timer
	wormTimer = Timer.new()
	wormTimer.wait_time = 1.0
	wormTimer.timeout.connect(_on_worm_timer_timeout)
	add_child(wormTimer)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("moveUp") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("moveDown") and is_on_floor():
		collision_mask &= ~(1 << 1)
		isDigging = true
		v = 500
		await get_tree().create_timer(1).timeout
	if isDigging:
		particles.emitting = true
		var direction := Input.get_axis("moveLeft", "moveRight")
		if direction > 0:
			animated_sprite.flip_h = false;
		elif direction < 0:
			animated_sprite.flip_h = true;
		
		if direction == 0:
			particles.emitting = false
			animated_sprite.play("jump")
			animated_sprite.rotation = deg_to_rad(0) 
		else:
			particles.emitting = true
			animated_sprite.play("run")
			if direction < 0:
				animated_sprite.rotation = deg_to_rad(-20) 
			else:
				animated_sprite.rotation = deg_to_rad(20)
		if Input.is_action_pressed("moveDown"):
			isDigging = true
			v = 200
		if Input.is_action_pressed("moveUp"):
			v = -200
		velocity.y = v
		v = 0
		#rigid_body.gravity_scale = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	if direction > 0:
		animated_sprite.flip_h = false;
	elif direction < 0:
		animated_sprite.flip_h = true;
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
			animated_sprite.rotation = deg_to_rad(0) 
		else:
			animated_sprite.play("run")
			if direction < 0:
				animated_sprite.rotation = deg_to_rad(-20) 
			else:
				animated_sprite.rotation = deg_to_rad(20)
	elif not isDigging:
		animated_sprite.play("jump")
			
	
	if direction:
		var walking: AudioStreamPlayer2D = $walking
		if not walking.playing:
			walking.playing = true;
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_non_dig_detector_body_exited(body: Node2D) -> void:
	isDigging = false
	collision_mask |= (1 << 1)
	particles.emitting = false

func add_worm():
	numWorms += 1
	print("added worm")
	
	if(numWorms == 1):
		# starts worm timer after getting 1st worm
		wormTimer.start()
		
func _on_worm_timer_timeout():
	if speed > 0:
		hit_by_worm()
	else:
		speed = 0
		jump_velocity = 0
		wormTimer.stop()
		
func hit_by_worm():
	for i in numWorms:
		speed -= 1
		jump_velocity += 1
		
	
	if speed <= 10:
		kill_player();
	
	print(speed)
	
func kill_player():
	speed = 0
	jump_velocity = 0
	
	isDigging = false
	isDead = true
	
	await get_tree().create_timer(3).timeout
	# reloads the scene
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("you died")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	get_tree().reload_current_scene()
	
