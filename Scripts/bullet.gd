extends Area2D

var speed = 400.0  # Velocidade do projétil
var direction = Vector2.RIGHT  # Direção inicial (será definida ao instanciar)
var damage = 50.0  # Dano causado aos macacos (ajuste conforme necessário)

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("macaco"):  # Verifica se colidiu com um macaco:
		body.take_damage(damage)
	queue_free() 
