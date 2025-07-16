extends Node2D

@export var macaco_scene: PackedScene = preload("res://Scenes/macaco.tscn") # Cena do macaco (ex.: macaco.tscn)
@export var spawn_distance: float = 320.0  # Distância fixa do jogador
@export var max_macacos: int = 100  # Limite de macacos vivos
@export var map_bounds_min: Vector2 = Vector2(-3600, -2050)  # Limites mínimos do mapa
@export var map_bounds_max: Vector2 = Vector2(3800, 2400)  # Limites máximos do mapa
@export var max_spawn_attempts: int = 10  # Máximo de tentativas para encontrar posição válida

var player: Node  # Referência ao jogador
var spawn_timer: float = 0.0

func _ready() -> void:
	# Encontra o jogador pelo grupo "Player"
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_error("Nenhum jogador encontrado no grupo 'Player'!")
		set_process(false)

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("macaco").size() >= max_macacos:
		return  # Não spawnar se o limite de macacos for atingido

	spawn_timer += delta
	if spawn_timer >= Manager.spawn_interval:
		spawn_macaco()
		spawn_timer = 0.0

func spawn_macaco() -> void:
	if not player or not macaco_scene:
		return

	# Tenta encontrar uma posição válida dentro do mapa
	var spawn_position = Vector2.ZERO
	var attempts = 0
	while attempts < max_spawn_attempts:
		print("tentativa ", attempts)
		# Calcula uma posição em um anel a 300px do jogador
		var angle = randf() * 2 * PI  # Ângulo aleatório em radianos
		spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance
		
		# Verifica se a posição está dentro dos limites do mapa
		if is_position_in_bounds(spawn_position):
			break
		attempts += 1
	
	# Se não encontrou posição válida, não spawna
	if attempts >= max_spawn_attempts:
		return
	
	# Instancia o macaco
	print("instanciando")
	var macaco = macaco_scene.instantiate()
	macaco.global_position = spawn_position
	get_parent().add_child(macaco)  # Adiciona o macaco como filho do nó principal

func is_position_in_bounds(pos: Vector2) -> bool:
	return (pos.x >= map_bounds_min.x and pos.x <= map_bounds_max.x and
			pos.y >= map_bounds_min.y and pos.y <= map_bounds_max.y)
