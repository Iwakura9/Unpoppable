extends Area2D

var speed = 400.0  # Velocidade do projétil
var direction = Vector2.RIGHT  # Direção inicial (será definida ao instanciar)
var damage = 50.0  # Dano causado aos macacos (ajuste conforme necessário)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	print("Projétil colidiu com:", body.name, "Grupos:", body.get_groups())
	if body.is_in_group("macaco"):  # Verifica se colidiu com um macaco
		# Aplica dano ao macaco (assumindo que macacos têm um método take_damage)
		print("Macaco detectado, aplicando dano:", damage)
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()  # Destroi o projétil após acertar
