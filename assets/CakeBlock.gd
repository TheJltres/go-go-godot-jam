extends RigidBody2D

var instance
var attached=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attach(location, block):
	instance = PinJoint2D.new()
	instance.position = location
	instance.node_a = self
	instance.node_b = block
	add_child(instance)
