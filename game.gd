extends Node3D

const CubeScene = preload("res://cube.tscn")
const GRID_WIDTH = 16
const GRID_HEIGHT = 16
const NUMBER_OF_MINES = 40
const CUBE_DISTANCE = 1.0
const DROP_INCREASE = 1
var drop_intensity = 1.5
var game_over = false
var game_started = false
var game_won = false
var cubes
var all_uncleared_cubes_are_mines: bool = false
var mine_num: int
var play_time: float = 0.0

func _ready() -> void:
	randomize()
	spawn_grid()

func spawn_grid():
	for h in range(GRID_HEIGHT):
		for w in range(GRID_WIDTH):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(h * CUBE_DISTANCE, 0, w * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			cube_instance.game_over.connect(on_game_over)
			cube_instance.cube_was_cleared.connect(on_cube_was_cleared)
			add_child(cube_instance)
	
	cubes = get_tree().get_nodes_in_group("cubes")
	cubes.shuffle()
	for node in cubes:
		if node.is_bomb:
			mine_num += 1

func randomized_mines(ignore_index: int):
	var mine_list := []
	for i in range(NUMBER_OF_MINES):
		mine_list.append(1)
	var not_mine_list := []
	for i in range(GRID_WIDTH * GRID_HEIGHT - NUMBER_OF_MINES):
		not_mine_list.append(0)
	var fullList := mine_list + not_mine_list
	fullList.shuffle()
	while fullList[ignore_index] == 1:
		fullList.shuffle()
	return fullList

func set_mines(ignore_index):
	var mine_list = randomized_mines(ignore_index)
	for i in range(cubes.size()):
		cubes[i].is_bomb = mine_list[i]

func on_game_over():
	game_over = true
	for node in cubes:
		if node and not node.is_queued_for_deletion():
			node.reveal_cube()
	
	$"../Camera3D".start_shake(.4, 1.0)
	for node in cubes:
		if node and not node.is_queued_for_deletion():
			node.enable_gravity()
			var timer2 = get_tree().create_timer(drop_intensity)
			await timer2.timeout

func on_cube_was_cleared(this_cube_instance):
	if !game_started:
		this_cube_instance.is_bomb = false
		var index_to_ignore = cubes.find(this_cube_instance)
		set_mines(index_to_ignore)
		game_started = true

	# TODO: keep a list of uncleared and cleared cubes
	# calculate number of cleared cubes
	all_uncleared_cubes_are_mines = true
	for node in cubes:
		if !node.is_cleared and !node.is_bomb:
			all_uncleared_cubes_are_mines = false
	
	if all_uncleared_cubes_are_mines and !game_over:
		game_won = true
		$"../WinBackground".visible = true
		$"../YOUWON".text = "You won! \n Time used: " + str("%.1f" % play_time, "s")

func _process(delta):
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
