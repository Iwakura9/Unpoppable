extends Node

var kill_record = 0
var kill_count = 0
var vidas_player = 3
var spawn_interval = 2.0
var can_spawn = true
var can_player_kill = true
var is_player_dead = false

const NORMAL_SIZE = 64  # Tamanho normal da fonte
const BIG_SIZE = 92    # Tamanho aumentado
const ANIMATION_TIME = 0.2

func reset() -> void:
	kill_count = 0
	vidas_player = 3
	spawn_interval = 2.0
	can_spawn = true
	is_player_dead = false
	
func add_kill() -> void:
	kill_count += 1
	atualiza_hud()
	verifica_upgrades(kill_count)
	
func player_heal() -> void:
	var player = get_node("/root/Game/Balum")
	if vidas_player < 3:
		vidas_player += 1
		muda_cor_balum(vidas_player)
		player.HealAnimation()
	
func player_toma_dano() -> void:
	var player = get_node("/root/Game/Balum")
	vidas_player -= 1
	muda_cor_balum(vidas_player)
	if vidas_player <= 0 and is_player_dead == false:
		player.morre()

func atualiza_hud() -> void:
	var kills_label = get_node_or_null("/root/Game/HUD/KillCounter")
	if kills_label:
		kills_label.text = "Kills: " + str(kill_count)
		animate_font_size(kills_label)
		
func muda_cor_balum(vidas: int) -> void:
	var sprite_balum = get_node_or_null("/root/Game/Balum/AnimatedSprite2D")
	match vidas:
		3:
			sprite_balum.play("Verde")
		2:
			sprite_balum.play("Azul")
		1:
			sprite_balum.play("Vermelho")
		0:
			sprite_balum.play("Morte")
	
func verifica_upgrades(kills: int) -> void:
	var player = get_node("/root/Game/Balum")
	var deu_match: bool = false
	match kills:
		10:
			show_round(2)
			player.troca_arma(preload("res://Scenes/armas/uzi.tscn"))
			spawn_interval = 1.5
			deu_match = true
		30:
			show_round(3)
			player.troca_arma(preload("res://Scenes/armas/Escopeta.tscn"))
			spawn_interval = 1
			deu_match = true
		50:
			show_round(4)
			player.troca_arma(preload("res://Scenes/armas/fuzil.tscn"))
			spawn_interval = 0.5
			deu_match = true
		100:
			show_round(5)
			player.troca_arma(preload("res://Scenes/armas/minigun.tscn"))
			spawn_interval = 0.25
			deu_match = true
			
		200:
			show_round("inf")
			spawn_interval = 0.1
			deu_match = true

	if deu_match:
		player_heal()
	

func show_round(round) -> void:
	# para de spawnar macacos
	can_spawn = false
	can_player_kill = false
	
	# matar todos os macacos
	for macaco in get_tree().get_nodes_in_group("macaco"):
		macaco.mata_macaco()
	
	# cria layer centralizador
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10 # Camada alta para garantir que fique acima de outros nós
	get_tree().current_scene.add_child(canvas_layer)
	
	# cria texto
	var round_label = Label.new()
	round_label.text = "Round " + str(round)
	round_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	round_label.add_theme_color_override("font_color", Color.RED)
	round_label.add_theme_font_size_override("font_size", 64)
	var font = load("res://Assets/Fonts/alagard/alagard.ttf")
	round_label.add_theme_font_override("font", font)
	
	# centraliza texto
	round_label.set_anchors_preset(Control.PRESET_CENTER)
	canvas_layer.add_child(round_label)
	round_label.offset_top -= 250 
	round_label.offset_left -= 120
	
	# Criar tween para fade-out
	var tween = get_tree().create_tween()
	tween.tween_property(round_label, "modulate:a", 0.0, 1.0).set_delay(1.0) 
	tween.tween_callback(round_label.queue_free)
	
	await get_tree().create_timer(2.0).timeout
	can_spawn = true
	can_player_kill = true
	

func animate_font_size(label) -> void:
	var tween = label.create_tween()
	if tween:
		label.add_theme_font_size_override("font_size", NORMAL_SIZE)
		tween.tween_property(label, "theme_override_font_sizes/font_size", BIG_SIZE, ANIMATION_TIME / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(label, "theme_override_font_sizes/font_size", NORMAL_SIZE, ANIMATION_TIME / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(ANIMATION_TIME / 2)
