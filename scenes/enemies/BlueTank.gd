extends PathFollow2D

var speed = 100.0
var hp = 1000

onready var health_bar = get_node("HealthBar")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)
	
func _physics_process(delta):
	if unit_offset >= 1:
		 self.queue_free()
	move(delta)

func move(delta):
	health_bar.set_position(position - Vector2(30,30))
	set_offset(get_offset() + (speed * delta) + 1)

func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func on_destroy():
	self.queue_free()
