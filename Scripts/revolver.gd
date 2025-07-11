extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var ponta = $ponta
@onready var sparks = $ponta/EfeitoTiro
@export var revolver_distance = 20.0  # Distância do revolver ao centro do jogador
@export var bullet_scene = preload("res://Scenes/bullet.tscn")
@export var fire_rate = 0.25
@export var auto_fire = false
var fire_timer = fire_rate

func _ready():
	# Posiciona o sprite do revolver a uma distância fixa do centro
	sprite.position = Vector2(revolver_distance, 0)
	$ponta.position = Vector2(revolver_distance + 5.0, 3.0)
	sparks.visible = false

func _process(delta):
	# Obtém a posição do mouse e calcula a direção
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Aplica a rotação ao nó Revolver
	rotation = direction.angle()
	if direction.x < 0:
		sprite.flip_v = true
		$ponta.position = Vector2(revolver_distance + 7.0, 3.0)
	else:
		sprite.flip_v = false
		$ponta.position = Vector2(revolver_distance + 7.0, -3.0)
	
	fire_timer -= delta
	if auto_fire:
		if fire_timer <= 0:
			fire_bullet(direction)
			fire_timer = fire_rate
	
	else:
		if Input.is_action_just_pressed("shoot") and fire_timer <= 0:
			fire_bullet(direction)
			fire_timer = fire_rate
			
			
func fire_bullet(direction):
	sparks.stop()
	sprite.stop()
	sparks.visible = true
	sparks.play("efeito")
	sprite.play("shoot")
	
	var bullet = bullet_scene.instantiate()
	bullet.position = ponta.global_position  # Começa na posição do muzzle
	bullet.direction = direction
	bullet.rotation = rotation  # Alinha a rotação do projétil com o revolver
	get_tree().root.add_child(bullet)  # Adiciona o projétil ao mundo
