extends Node

var kill_count = 0
var vidas_player = 3
var spawn_interval = 2.0

const NORMAL_SIZE = 64  # Tamanho normal da fonte
const BIG_SIZE = 92    # Tamanho aumentado
const ANIMATION_TIME = 0.2

func reset() -> void:
	kill_count = 0
	vidas_player = 3
	spawn_interval = 2.0
	
func add_kill() -> void:
	kill_count += 1
	atualiza_hud()
	verifica_upgrades(kill_count)
	
func player_toma_dano() -> void:
	vidas_player -= 1
	if vidas_player <= 0:
		get_tree().reload_current_scene()
		reset()
	
func atualiza_hud() -> void:
	var kills = get_node_or_null("/root/Game/HUD/KillCounter")
	if kills:
		kills.text = str(kill_count)
		animate_font_size(kills)
	
func verifica_upgrades(kills: int) -> void:
	pass

func animate_font_size(label) -> void:
	var tween = label.create_tween()
	if tween:
		label.add_theme_font_size_override("font_size", NORMAL_SIZE)
		tween.tween_property(label, "theme_override_font_sizes/font_size", BIG_SIZE, ANIMATION_TIME / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(label, "theme_override_font_sizes/font_size", NORMAL_SIZE, ANIMATION_TIME / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(ANIMATION_TIME / 2)
