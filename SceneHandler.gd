extends Node
## ----- custom funcs -----
func on_new_game_pressed():
	get_node("NodeWrapper").queue_free()
	var game_scene = load("res://scenes/MainScenes/GameScene.tscn").instance()
	add_child(game_scene)
	pass

func on_quit_pressed():
	get_tree().quit()

## ----- Default functions -----
func _ready():
	get_node("NodeWrapper/MainMenu/margin/vb/NewGame").connect("pressed",self,"on_new_game_pressed")
	get_node("NodeWrapper/MainMenu/margin/vb/Quit").connect("pressed",self,"on_quit_pressed")
