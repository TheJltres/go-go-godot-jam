extends Node2D


var current_block
var plant_block = load("res://Scenes/PlantBlock.tscn")
var cloud= load("res://Scenes/Cloud.tscn")
var instance
var sway_amount = 50
var sway_time = 2

var score = 0
var combo = 0
var perfect = 0
var max_combo = 0
var height = 0
var health = 3

var blocks_put= 0
var random = 0


const SPAWN_DISTANCE = Vector2(0, -60)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_block = get_node("PlantBlock")
	spawn_block()
	
func _physics_process(delta):
	$Camera2D.position = lerp($Camera2D.position, current_block.position, 0.05)
	
func spawn_block():
	instance = plant_block.instance()
	add_child(instance)
	instance.initialize(current_block.position + SPAWN_DISTANCE, sway_amount, sway_time, current_block)
	sway_amount += 1
	if sway_time > 1.4:
		sway_time -= 0.05
	else:
		sway_time = lerp(sway_time, 0.8, 0.05)
		
func increment_score(num):
	blocks_put += 1
	if num == 200:
		height += 1
		score += num + 50 * combo
		combo += 1
		perfect += 1
		if combo > max_combo:
			max_combo = combo
	elif num == 150:
		score += num
		combo = 0
	elif num == 100:
		height += 1
		score += num
		combo = 0
	else:
		combo = 0
		health -= 1
		if health == 2:
			$Camera2D/CanvasLayer/heart3.visible = false
		elif health == 1:
			$Camera2D/CanvasLayer/heart2.visible = false
		elif health < 1:
			$Camera2D/CanvasLayer/heart.visible = false
			Global.height = height
			Global.score = score
			Global.max_combo = max_combo
			Global.perfect = perfect
			if get_tree().change_scene("res://Plugins/RhythmEndScreen/End.tscn") != OK:
				print ("Error changin scene to End")
	
	$Camera2D/CanvasLayer/ScoreLabel.text = str(score)
	if combo != 0:
		$Camera2D/CanvasLayer/ComboLabel.text = str(combo) + " combo!"
	else:
		$Camera2D/CanvasLayer/ComboLabel.text = ""	

func _on_Timer_timeout():
	random = randi() % 30
	if random + blocks_put > 40:
		instance = cloud.instance()
		if randi() % 2 == 1:
			instance.position.x = -40
		else:
			instance.position.x = 360
		instance.position.y = current_block.position.y + 70 - randi() % 240
		add_child(instance)
