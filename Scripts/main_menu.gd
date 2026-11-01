extends Node

const PAN_SPEED = 30.0
const MONKEYS_PER_LEG = 8

var macaco_scene := preload("res://Scenes/macaco.tscn")
var map_rect: Rect2
@onready var camera: Camera2D = $Camera2D
@onready var world: Node2D = $World

func _ready() -> void:
	%Record.text = "Best: " + str(Manager.kill_record)
	%Start.grab_focus()

	# Reaproveita o mapa do jogo, descartando tudo que não é cenário
	var game = preload("res://Scenes/game.tscn").instantiate()
	for child in game.get_children():
		if child.name not in ["TileMap", "Limits"]:
			child.free()
	world.add_child(game)

	var tilemap: TileMap = game.get_node("TileMap")
	var tile := Vector2(tilemap.tile_set.tile_size)
	var used := tilemap.get_used_rect()
	map_rect = Rect2(Vector2(used.position) * tile, Vector2(used.size) * tile).grow(-300)

	camera.position = map_rect.position + Vector2(randf(), randf()) * map_rect.size
	for i in MONKEYS_PER_LEG:
		spawn_monkey(camera.position + Vector2(randf_range(-300, 300), randf_range(-200, 200)))
	pan()

# Câmera vai devagar até um ponto próximo e escolhe outro, pra sempre.
func pan() -> void:
	var target = camera.position + Vector2.from_angle(randf() * TAU) * randf_range(500, 900)
	target = target.clamp(map_rect.position, map_rect.end)

	# Some com macacos que ficaram pra trás e põe novos no caminho, fora da tela
	for m in get_tree().get_nodes_in_group("macaco"):
		if m.global_position.distance_to(camera.position) > 1200:
			m.queue_free()
	for i in MONKEYS_PER_LEG:
		var pos = camera.position.lerp(target, randf_range(0.4, 1.0)) + Vector2(randf_range(-350, 350), randf_range(-250, 250))
		if pos.distance_to(camera.position) > 400:
			spawn_monkey(pos)

	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "position", target, camera.position.distance_to(target) / PAN_SPEED)
	tween.tween_callback(pan)

func spawn_monkey(pos: Vector2) -> void:
	var m = macaco_scene.instantiate()
	m.position = pos
	world.add_child(m)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()
