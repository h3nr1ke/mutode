extends Node2D

signal game_finished(result)

var map_node

var build_mode = false
var build_valid = false
var build_location
var build_tile
var build_type
# --- wave vars ---
var current_wave = 0
var enemies_in_wave = 0
# --- player info ---
var base_health = 100

## ----- Custom Funcs -----
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	## node references
	var tower_exclusion = map_node.get_node("TowerExclusion")
	var ui = get_node("UI")
	
	## tile references
	var mouse_position = get_global_mouse_position()
	var current_tile = tower_exclusion.world_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_world(current_tile)
	
	if tower_exclusion.get_cellv(current_tile) == -1:
		ui.update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else: 
		ui.update_tower_preview(tile_position, "adff4545")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	## was queue_free delete in the next frame
	## free delete in the current frame
	get_node("UI/TowerPreview").free()

func verify_and_build():
	print("verify_and_build")
	if build_valid:
		var tower_data = GameData.tower_data[build_type]
		var new_tower = load("res://scenes/turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location + Globals.tower_offset
		new_tower.get_node("Range/Area").shape.radius = tower_data["range"] / 2.0
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = tower_data["category"]
		map_node.get_node("Turrets").add_child(new_tower,true)
		# trick to avoid add tower over tower
		map_node.get_node("TowerExclusion").set_cellv(build_tile, Globals.transparent_tile_id)

## ----- wave functions -----

func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2),"timeout")
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = [["BlueTank", 0.7],["BlueTank", 0.7], ["BlueTank", 0.7],["BlueTank", 0.7],["BlueTank", 0.7],["BlueTank", 0.7],["BlueTank", 0.7],["BlueTank", 0.7],["BlueTank", 0.7]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://scenes/enemies/" + i[0] + ".tscn").instance()
		new_enemy.connect("base_damage", self, "on_base_damage")
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")

func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		get_node("UI").update_health_bar(0)
		yield(get_tree().create_timer(1), "timeout")
		emit_signal("game_finished", false)
	else:
		get_node("UI").update_health_bar(base_health)
			
## ----- Default Functions -----

## everthing is already loaded (scenes and nodes)
func _ready():
	# get the map scene
	map_node = get_node("Map1")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	pass

func _process(delta):
	if build_mode:
		update_tower_preview()
	pass

## befor handle here, go to Project > Project Settings > Input Map and configure
## the input for the mouse
func _unhandled_input(event): 
	if event.is_action_released("ui_cancel") and build_mode == true: 
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
	pass

