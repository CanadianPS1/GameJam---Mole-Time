extends CharacterBody2D

const JUMP_VELOCITY = -200.0
var inGround = false
var speed = 200.0
var numWorms = 0
var isDigging = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func add_worm():
	numWorms += 1
	print("added worm")

@onready var rigid_body: RigidBody2D = $CollisionShape2D/RigidBody2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("moveUp") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("moveDown") and is_on_floor():
		print("in grounds")
		collision_mask &= ~(1 << 1)
		rigid_body.gravity_scale = 0
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
	else:
		animated_sprite.play("jump")
			
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
