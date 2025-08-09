extends Node2D

var player: CharacterBody2D

func _ready():
	player = get_node("../Player")
	
	if has_node("DetectionFeild"):
		$DetectionFeild.body_entered.connect(_on_detection_radius_body_entered)
		
	if has_node("HitBox"):
		$HitBox.body_entered.connect(_on_hit_box_body_entered)
		

func _on_detection_radius_body_entered(delta):
	pass
	


func _on_hit_box_body_entered(body):
	if body.has_method("kill_player"):
		body.kill_player()
