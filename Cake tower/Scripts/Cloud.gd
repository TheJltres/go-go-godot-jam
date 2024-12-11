extends AnimatedSprite


var speed


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	speed = randf() * 10 + 12
	frame = randi() % 4
	if position.x < 0:
		$Tween.interpolate_property(self, "position:x", position.x, 360, speed)
	else:
		$Tween.interpolate_property(self,"position:x", position.x, -40, speed)
	$Tween.start()
	z_index = randi() % 3 - 2
	
func _on_Tween_tween_completed(_object, _key):
	queue_free()
