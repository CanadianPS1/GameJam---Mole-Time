extends Area2D

func _ready():
	# Connect the body entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if it's the player
	if body.name == "CharacterBody2D" or body.has_method("add_worm"):
		trigger_win()

func trigger_win():
	# Find the win screen in the current scene
	var win_screen = find_win_screen()
	
	if win_screen:
		win_screen._on_goal_collected()
		# Disable this area so it can't be triggered again
		set_deferred("monitoring", false)
		visible = false
	else:
		print("Error: Could not find win screen!")

# Search for the win screen in the scene tree
func find_win_screen() -> Control:
	var root = get_tree().current_scene
	return search_for_winscreen(root)

func search_for_winscreen(node: Node) -> Control:
	# Check if this node is the win screen
	if node.name.to_lower().contains("winscreen") or node.name.to_lower().contains("win"):
		if node is Control and node.has_method("_on_goal_collected"):
			return node as Control
	
	# Search children recursively
	for child in node.get_children():
		var result = search_for_winscreen(child)
		if result:
			return result
	
	return null
