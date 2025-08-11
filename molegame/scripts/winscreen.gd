extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	
	if has_node("ColorRect"):
		var bg = $ColorRect
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	# Connect buttons
	if has_node("VBoxContainer/Restart"):
		$VBoxContainer/Restart.pressed.connect(_on_restart_pressed)
		$VBoxContainer/Restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	if has_node("VBoxContainer/Exit"):
		$VBoxContainer/Exit.pressed.connect(_on_exit_pressed)
		$VBoxContainer/Exit.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_goal_collected():
	visible = true
	get_tree().paused = true
	
	# Make sure all child nodes can process when paused
	var container = $VBoxContainer
	container.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	for child in container.get_children():
		child.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_restart_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_exit_pressed():
	get_tree().quit()
