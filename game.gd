extends Node3D

const CubeScene = preload("res://cube.tscn")
const GRID_WIDTH = 16
const GRID_HEIGHT = 16
const CUBE_DISTANCE = 1.0
const DROP_INCREASE = 1
var drop_intensity = 1.5
var game_over = false
var game_started = false
var game_won = false
var nodes
var all_uncleared_cubes_are_mines: bool = false
var mine_num: int
var play_time: float = 0.0

func _ready() -> void:
	randomize()
	spawn_grid()

func spawn_grid():
	# instantiate cubes
	for h in range(GRID_HEIGHT):
		for w in range(GRID_WIDTH):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(h * CUBE_DISTANCE, 0, w * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			add_child(cube_instance)
			
			# connect cube signals
			cube_instance.game_over.connect(on_game_over)
			cube_instance.game_start.connect(on_game_start)
			cube_instance.cube_was_cleared.connect(on_cube_was_cleared)
	# add them to group
	nodes = get_tree().get_nodes_in_group("cubes")
	nodes.shuffle()
	for node in nodes:
		if node.is_bomb:
			mine_num += 1

func on_game_start():
	game_started = true

func on_game_over():
	game_over = true
	for node in nodes:
		if node and not node.is_queued_for_deletion():
			node.reveal_cube()
	
	$"../Camera3D".start_shake(.4, 1.0)
	for node in nodes:
		if node and not node.is_queued_for_deletion():
			node.enable_gravity()
			var timer2 = get_tree().create_timer(drop_intensity)
			await timer2.timeout

func on_cube_was_cleared():
	# IMPROVEMENT: keep a list of uncleared and cleared cubes
	# calculate number of cleared cubes
	all_uncleared_cubes_are_mines = true
	for node in nodes:
		if !node.is_cleared and !node.is_bomb:
			all_uncleared_cubes_are_mines = false
	
	# check if game is won
	if all_uncleared_cubes_are_mines and !game_over:
		game_won = true
		$"../WinBackground".visible = true
		$"../YOUWON".text = "You won! \n Time used: " + str("%.1f" % play_time, "s")

func _physics_process(delta):
	if game_started and !game_won and !game_over:
		play_time += delta
	$"../Timer".text = str("%.1f" % play_time, "s")
	
	if Input.is_action_pressed("restart"):
		on_restart_button_pressed()
	
	if game_over:
		if drop_intensity >= 0.0:
			# Reduce the shake intensity over time
			drop_intensity -= DROP_INCREASE * delta

func on_restart_button_pressed():
	get_tree().reload_current_scene()
