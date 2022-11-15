extends CanvasLayer

func set_tower_preview(tower_type, mouse_position):
	# create the tower selector indicator
	var tower_selector = load("res://scenes/UIScenes/TowerHighlight.tscn").instance()
	tower_selector.set_name("TowerHighlight")
	
	# add the animation of the range indicator
	var range_indicator = load("res://scenes/UIScenes/RangeIndicator.tscn").instance()
	range_indicator.set_name("TowerRangeIndicator")
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0 # tem de ter o .0 para que seja float
	range_indicator.scale = Vector2(scaling,scaling)
	range_indicator.modulate = Color("ad54ff3c")
	
	# create the tower being drag by the user
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	# add evertything in the screen
	var control = Control.new()
	control.add_child(range_indicator, true)
	control.add_child(drag_tower, true)
	control.add_child(tower_selector, true)
	control.rect_position = mouse_position + Globals.tower_offset
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position + Globals.tower_offset
	var drag_tower = get_node("TowerPreview/DragTower")
	var range_indicator = get_node("TowerPreview/TowerRangeIndicator")
	var _color = Color(color)
	if drag_tower.modulate != _color:
		drag_tower.modulate = _color
		range_indicator.modulate = _color

# ----- SIGNALS -----
func _on_PausePlay_pressed():
	var parent = get_parent()
	var tree = get_tree()
	
	if parent.build_mode:
		parent.cancel_build_mode()

	if tree.is_paused():
		tree.paused = false
		parent.start_next_wave()
	# call to start if the game was not started
	#elif parent.current_wave == 0:
		# parent.current_wave = 1
	else:
		tree.paused = true
		
func _on_SpeedUp_pressed():
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else: 
		Engine.set_time_scale(2.0)
		
