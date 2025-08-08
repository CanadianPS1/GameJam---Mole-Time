extends Node2D

@export var speed = 75

var player: CharacterBody2D

func _ready():
	#I had to flip it lol
	$AnimatedSprite2D.flip_h = true;
	player = get_node("../Player")
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	
	global_position += direction * speed * delta
	
	if direction.x >= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
