extends CanvasLayer

func _ready() -> void:
	if Manager.kill_count > Manager.kill_record:
		Manager.kill_record = Manager.kill_count
	$KillContainer/KillCounter.text = "Kills: " + str(Manager.kill_count)
	$KillContainer/KillRecord.text = "Best: " + str(Manager.kill_record)
	
	var musica = get_node("/root/Game/Balum/Musica")
	stop_music_with_effect(musica)
	# pitch_down e slow down até a música parar (2 segundos)
	
	get_node("/root/Game/HUD").queue_free()
	Engine.time_scale = 0.25
	

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Manager.reset()
	queue_free()
	Engine.time_scale = 1

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	Manager.reset()
	queue_free()
	Engine.time_scale = 1
	
func stop_music_with_effect(musica):
	var tween = create_tween()
	tween.tween_property(musica, "pitch_scale", 0.0, 2.0).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(musica, "volume_db", -80.0, 2.0).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(musica.stop)
	tween.tween_callback(func(): musica.pitch_scale = 1.0)
	tween.tween_callback(func(): musica.volume_db = 0.0)
