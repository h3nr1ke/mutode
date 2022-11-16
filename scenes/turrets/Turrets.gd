extends Node2D

var enemy_array = []
var type 
var category
var built = false
var enemy
var ready = true
## ----- Custom Functions -----
func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	ready = false
	if category == "Projectile":
		fire_gun()
	elif category == "Missile":
		fire_missile()
	
	var tower_data = GameData.tower_data[type]
	enemy.on_hit(tower_data["damage"])
	yield(get_tree().create_timer(tower_data["rof"]),"timeout")
	ready = true

func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	pass

func fire_missile():
	pass	
## ----- Default functions -----
func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		## to prevent move turret before the animation end
		if not get_node("AnimationPlayer").is_playing():
			turn()
			
		if ready:
			fire()
	pass

## ----- SIGNALS -----
func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
