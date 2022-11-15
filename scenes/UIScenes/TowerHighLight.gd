extends Sprite

var temp_delta = 0
var direction = true

func _process(delta):
	if temp_delta < 20:
		var vectorSpeed = 2 if !direction else -2
		var newOffset = self.offset + Vector2(vectorSpeed,vectorSpeed)
		if newOffset < Globals.tower_selector_min:
			 newOffset = Globals.tower_selector_min
			
		if newOffset > Globals.tower_selector_max:
			 newOffset = Globals.tower_selector_max

		self.offset = newOffset
		
		## different values here to ensure a bounce not so linear
		temp_delta = temp_delta + (delta * (80 if !direction else 80 ) )
	else:
		direction = !direction
		temp_delta = 0
	pass
