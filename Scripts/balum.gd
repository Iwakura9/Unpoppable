extends CharacterBody2D

const SPEED = 85
var is_immune = false
@onready var arma_atual = get_node("/root/Game/Balum/Revolver")

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	velocity = input_vector * SPEED
	move_and_slide()
	
func take_damage(damage: float) -> void:
	if not is_immune:
		$Pop.play()
		Manager.player_toma_dano()
		if Manager.vidas_player > 0:
			is_immune = true
			$TempoImunidade.start()
			_start_blinking()
			
func troca_arma(nova_arma: PackedScene) -> void:
	if arma_atual:
		arma_atual.queue_free()
		
		
	arma_atual = nova_arma.instantiate()
	add_child(arma_atual)

			
func _start_blinking():
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.5, 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)
	tween.set_loops(2)  # Repete 2 vezes (0.3s no total)

func _stop_blinking():
	var sprite = $Sprite2D
	sprite.modulate = Color(1, 1, 1, 1)	
func _on_tempo_imunidade_timeout() -> void:
	is_immune = false
	_stop_blinking()
	
