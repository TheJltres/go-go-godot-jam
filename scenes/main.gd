extends Node2D

@onready var pastel = $CakeBase
@onready var camera = $Camera2D

var moving_right = true
var is_dropping = false
var fall_speed = 300.0

func _ready():
	# Mueve el pastel lateralmente al inicio
	move_pastel()

func move_pastel():
	# Define los límites del movimiento
	var left_limit = 50
	var right_limit = 500

	# Crea un Tween para mover el pastel
	var tween = create_tween()
	if moving_right:
		tween.tween_property(pastel, "position:x", right_limit, 3.0) # Se eliminan TRANS_LINEAR y EASE_IN_OUT
	else:
		tween.tween_property(pastel, "position:x", left_limit, 3.0) # Se eliminan TRANS_LINEAR y EASE_IN_OUT

	# Llama al movimiento inverso al completar la animación
	tween.tween_callback(Callable(self, "_on_tween_completed"))

func _on_tween_completed():
	if not is_dropping:
		# Cambia dirección cuando llega al límite
		moving_right = !moving_right
		move_pastel()

func _process(delta):
	# Dejar caer el pastel
	if is_dropping:
		pastel.position.y += fall_speed * delta

	# Mover la cámara hacia arriba cuando el pastel impacte
	if pastel.position.y > 400: # Cambia el valor según tu escena
		move_camera_up()

func _input(event):
	# Detecta la barra espaciadora para dejar caer el pastel
	if event.is_action_pressed("ui_accept") and not is_dropping:
		is_dropping = true
		# Detenemos cualquier tween activo
		create_tween().kill()

func move_camera_up():
	# Mueve la cámara hacia arriba para la próxima capa
	var tween = create_tween()
	tween.tween_property(camera, "position:y", camera.position.y - 200, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	# Reinicia el pastel después de mover la cámara
	tween.tween_callback(Callable(self, "reset_pastel"))

func reset_pastel():
	# Reinicia el pastel para la próxima capa
	pastel.position = Vector2(50, 100) # Cambia la posición inicial según tu diseño
	is_dropping = false
	move_pastel()
