extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var ponta = $ponta
@onready var sparks = $ponta/EfeitoTiro
@export var distance = 20.0  # Distância do revolver ao centro do jogador
@export var bullet_scene = preload("res://Scenes/bullet.tscn")
@export var fire_rate = 0.5
@export var auto_fire = false
@export var automatic = false
@export var ponta_dist_x = 7
@export var ponta_dist_y = 3
@export var max_spray = 0.05
@export var damage = 50.0
var fire_timer = fire_rate

func _ready():
	# Posiciona o sprite do revolver a uma distância fixa do centro
	sprite.position = Vector2(distance, 0)
	sparks.visible = false

func _process(delta):
	# Obtém a posição do mouse e calcula a direção
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Aplica a rotação ao nó Revolver
	rotation = direction.angle()
	if direction.x < 0:
		sprite.flip_v = true
		ponta.position = Vector2(distance + ponta_dist_x, ponta_dist_y)
	else:
		sprite.flip_v = false
		ponta.position = Vector2(distance + ponta_dist_x, -ponta_dist_y)
	
	fire_timer -= delta
	if auto_fire:
		if fire_timer <= 0:
			fire_bullet(direction, damage)
			fire_timer = fire_rate
	
	else:
		if Input.is_action_just_pressed("shoot") and fire_timer <= 0:
			fire_bullet(direction, damage)
			fire_timer = fire_rate
		
		if Input.is_action_pressed("shoot") and fire_timer <=0 and automatic:
			fire_bullet(direction, damage)
			fire_timer = fire_rate
			
			
func fire_bullet(direction, damage):
	if has_node("click"):
		$click.play()
	var shoot_pitch = randf_range(0.9, 1.1)
	$shoot.pitch_scale = shoot_pitch
	$shoot.play()
	
	sparks.stop()
	sprite.stop()
	sparks.visible = true
	sparks.play("efeito")
	sprite.play("shoot")
	
	var spray = randf_range(-max_spray, max_spray)
	direction = direction.rotated(spray)
	
	var bullet = bullet_scene.instantiate()
	bullet.damage = damage
	bullet.position = ponta.global_position  # Começa na posição do muzzle
	bullet.direction = direction
	bullet.rotation = direction.angle()  # Alinha a rotação do projétil com o revolver
	get_tree().root.add_child(bullet)  # Adiciona o projétil ao mundo
