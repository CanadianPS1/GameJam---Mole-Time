extends Node2D

var player: CharacterBody2D

func _ready():
	player = get_node("../Player")
	
	if has_node("HitBox"):
		pass
	else:
		print("no hitbox :P")
