extends Camera2D
@onready var timer: Timer = $"../Timer"

@onready var camera: Camera2D = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




func _on_timer_timeout() -> void:
	camera.enabled = false
