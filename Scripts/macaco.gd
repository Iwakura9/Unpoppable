extends CharacterBody2D

@export var speed: float = 60
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@export var vida = 100.0
var morreu = false

func _ready() -> void:
	add_to_group("macaco")
	print("Macaco", name, "instanciado em", global_position)

func _physics_process(delta: float) -> void:
	if player and not morreu:
		# Calcula direção do jogador
		var direction: Vector2 = (player.global_position - global_position).normalized()
		
		# Aplica movimento
		velocity = direction * speed
		move_and_slide()
		
		animate(direction)
		
func animate(direction: Vector2) -> void:
	# Pega o angulo do vetor direção e converte para graus.
	var angle: float = atan2(direction.y, direction.x)
	var angle_deg: float = rad_to_deg(angle)
	
	# Seta o nome da animação para dar play de acordo com o angulo
	var animation_name: String = "run_"
	if angle_deg >= -22.5 and angle_deg < 22.5:
		animation_name += "right"
	elif angle_deg >= 22.5 and angle_deg < 67.5:
		animation_name += "DR"
	elif angle_deg >= 67.5 and angle_deg < 112.5:
		animation_name += "down"
	elif angle_deg >= 112.5 and angle_deg < 157.5:
		animation_name += "DL"
	elif angle_deg >= 157.5 or angle_deg < -157.5:
		animation_name += "left"
	elif angle_deg >= -157.5 and angle_deg < -112.5:
		animation_name += "UL"
	elif angle_deg >= -112.5 and angle_deg < -67.5:
		animation_name += "up"
	elif angle_deg >= -67.5 and angle_deg < -22.5:
		animation_name += "UR"
		
	# Toca a animação se ela não já estiver tocando
	if sprite.animation != animation_name:
		sprite.play(animation_name)

func take_damage(damage: float) -> void:
	vida -= damage
	sprite.modulate = Color.RED
	
	# timer
	var timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()
	
	if vida <= 0:
		morreu = true
		sprite.play("morte")
		velocity = Vector2.ZERO
	else:
		position += -velocity*0.2
		
func _on_timer_timeout() -> void:
	sprite.modulate = Color.WHITE
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "morte":
		queue_free()
