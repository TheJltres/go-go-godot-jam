extends KinematicBody2D


var base_position = Vector2()
var sway_amount = 0

const GRAVITY = Vector2(0, 60)
var velocity = Vector2()

export var building = true
export var built = false
var going_right = true
var collision

const PERFECT_DISTANCE = 2.0
const GOOD_DISTANCE = 6.0


func _ready():
	pass


func _unhandled_input(event):
	if building and event.is_action_pressed("drop", false):
		$Tween.remove(self,"position:x")
		building = false
		
		
func _physics_process(delta):
	if !building and !built:
		velocity += GRAVITY * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_floor():
			collision = get_slide_collision(0)
			if collision.collider == get_parent().current_block:
				built = true
				get_parent().current_block = self
				get_parent().spawn_block()
			else:
				get_parent().spawn_block
				queue_free()
				
func initialize(pos, sway):
	base_position = pos
	position= pos
	position.x -= sway
	sway_amount = sway
	$Tween.interpolate_property(self,"position:x",position.x, base_position.x + sway_amount, 2.0)
	$Tween.start()




func _on_Tween_tween_completed(_object, _key):
	if going_right:
		$Tween.interpolate_property(self, "position:x", position.x, base_position.x - sway_amount, 2.0)
		$Tween.start()
		going_right = false
	else:
		$Tween.interpolate_property(self, "position:x", position.x, base_position.x + sway_amount, 2.0)
		$Tween.start()
		going_right = true
