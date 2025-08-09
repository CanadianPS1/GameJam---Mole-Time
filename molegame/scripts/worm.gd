extends Node2D

@export var speed = 45

var player: CharacterBody2D

func _ready():
	#I had to flip it lol
	$AnimatedSprite2D.flip_h = true;
	player = get_node("../Player")
	
	if has_node("HitBox"):
		$HitBox.body_entered.connect(_on_hit_box_body_entered)
	else:
		print("no hitbox :P")
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	
	global_position += direction * speed * delta
	
	if direction.x >= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		

func _on_hit_box_body_entered(body):
	
	print("hit detected on", body.name)
	
	if body.has_method("add_worm"):
		body.add_worm()
	else:
		print("lol loser")
	
	queue_free()
