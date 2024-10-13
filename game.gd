extends Node3D

const CubeScene = preload("res://cube.tscn")
const GRID_SIZE = 20
const CUBE_DISTANCE = 1.0
const drop_increase = 1
var drop_intensity = 1.5
var game_over = false
var nodes

func _ready() -> void:
	randomize()
	spawn_grid()

func spawn_grid():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(i * CUBE_DISTANCE, 0, j * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			add_child(cube_instance)
			
			# connect cube's game_over signal
			cube_instance.game_over.connect(_on_game_over)
	nodes = get_tree().get_nodes_in_group("cubes")
	nodes.shuffle()

func _on_game_over():
	game_over = true
	for node in nodes:
		if node and not node.is_queued_for_deletion():
			node.reveal_cube()
	
	var timer = get_tree().create_timer(drop_intensity)
	await timer.timeout
	$"../Camera3D".start_shake(.4, 1.0)
	
	for node in nodes:
		if node and not node.is_queued_for_deletion():
			node.enable_gravity()
			var timer2 = get_tree().create_timer(drop_intensity)
			await timer2.timeout

func _process(delta: float) -> void:
	if game_over:
		if drop_intensity >= 0.0:
			# Reduce the shake intensity over time
			drop_intensity -= drop_increase * delta