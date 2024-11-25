extends Node3D

const CubeScene := preload("res://shared/cube/Cube.tscn")

@onready var game_timer: Label = $"../HUD/InGameHUD/Timer"
@onready var background: ColorRect = $"../HUD/InGameHUD/Background"
@onready var time_used: Label = $"../HUD/InGameHUD/GameWonUI/TimeUsed"
@onready var game_won_ui: VBoxContainer = $"../HUD/InGameHUD/GameWonUI"
@onready var game_over_ui: VBoxContainer = $"../HUD/InGameHUD/GameOverUI"
@onready var remaining_mines_label: Label = $"../HUD/InGameHUD/RemainingMinesLabel"
@onready var hud: Control = $"../HUD"

@onready var camera: Camera3D = $"../Camera3D"
@onready var player: Node3D = $"../Player"

const GRID_WIDTH := 16
const GRID_HEIGHT := 16
const NUMBER_OF_MINES := 40
const NUMBER_OF_NOT_MINES := GRID_WIDTH * GRID_HEIGHT - NUMBER_OF_MINES
const CUBE_DISTANCE := 1.0
const DROP_INCREASE := 1
var drop_intensity := 1.5
var game_over: bool = false
var game_started: bool = false
var game_won: bool = false
var play_time := 0.0
var cubes
var cleared_cubes := []
var number_of_flags := 0

func _ready() -> void:
	randomize()
	spawn_grid()

func _process(delta):
	var game_in_progress = game_started and !game_won and !game_over
	if game_in_progress:
		play_time += delta
	game_timer.text = str("%.1f" % play_time, "s")
	remaining_mines_label.text = str(NUMBER_OF_MINES - number_of_flags)
	
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	
	if game_over:
		if drop_intensity >= 0.0:
			drop_intensity -= DROP_INCREASE * delta

func spawn_grid():
	for h in range(GRID_HEIGHT):
		for w in range(GRID_WIDTH):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(h * CUBE_DISTANCE, 0, w * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			cube_instance.game_over.connect(on_game_over)
			cube_instance.cube_was_cleared.connect(on_cube_was_cleared)
			cube_instance.cube_was_flagged.connect(on_cube_was_flagged)
			add_child(cube_instance)
	cubes = get_tree().get_nodes_in_group("cubes")
	cubes = cubes.filter(func(cube): return !(cube.isLoadingCleared or cube.isLoadingExploded) )

func randomized_mines(ignore_index: int):
	var mine_list := []
	for i in range(NUMBER_OF_MINES):
		mine_list.append(true)
	var not_mine_list := []
	for i in range(GRID_WIDTH * GRID_HEIGHT - NUMBER_OF_MINES):
		not_mine_list.append(false)
	var fullList := mine_list + not_mine_list
	fullList.shuffle()
	while fullList[ignore_index] == true:
		fullList.shuffle()
	return fullList

func set_mines(ignore_index):
	var mine_list = randomized_mines(ignore_index)
	for i in range(cubes.size()):
		cubes[i].is_bomb = mine_list[i]

func on_game_over():
	player.died()
	game_over = true
	game_over_ui.visible = true
	for node in cubes:
		if node and not node.is_queued_for_deletion():
			node.reveal_cube()
			node.remove_flag()
	
	camera.start_shake(.4, 1.0)
	for node in cubes:
		if node and not node.is_queued_for_deletion():
			var timer2 = get_tree().create_timer(drop_intensity)
			await timer2.timeout

func on_game_won():
	game_won = true
	background.visible = true
	time_used.text = "Time used: " + str("%.1f" % play_time, "s")
	game_won_ui.visible = true

func on_game_start(cleared_cube):
	hud.game_started()
	if !game_started:
		game_started = true
		cleared_cube.is_bomb = false
		var index_to_ignore = cubes.find(cleared_cube)
		set_mines(index_to_ignore)

func on_cube_was_cleared(cleared_cube):
	on_game_start(cleared_cube)
	
	cleared_cubes.append(cleared_cube)
	if !game_over and cleared_cubes.size() == NUMBER_OF_NOT_MINES:
		on_game_won()

func on_cube_was_flagged():
	number_of_flags = 0
	for cube in cubes:
		if cube.is_flagged:
			number_of_flags += 1
