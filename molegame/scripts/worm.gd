extends Node2D

@export var speed = 45

var is_chasing: bool = false

var player: CharacterBody2D

func _ready():
	#I had to flip it lol
	$AnimatedSprite2D.flip_h = true;
	player = get_node("../Player")
	
	if has_node("DetectionFeild"):
		$DetectionFeild.body_entered.connect(_on_detection_radius_body_entered)
		
	if has_node("HitBox"):
		$HitBox.body_entered.connect(_on_hit_box_body_entered)
	
func _process(delta):
	if is_chasing:
		chase_player(delta)

func _on_detection_radius_body_entered(body: CharacterBody2D):
	print("Plr Detected")
	player = body
	is_chasing = true

func chase_player(delta):
	
	if(player.isDigging):
		var direction = (player.global_position - global_position).normalized()

		global_position += direction * speed * delta
		
		if direction.x >= 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	

func _on_hit_box_body_entered(body):
	
	if body.has_method("add_worm"):
		body.add_worm()
	
	queue_free()
