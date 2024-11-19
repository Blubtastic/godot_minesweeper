extends StaticBody3D

@export var isLoadingCleared: bool = false
@export var isLoadingExploded: bool = false

@onready var reveal_cube_audio: AudioStreamPlayer = $RevealCube
@onready var place_flag_audio: AudioStreamPlayer = $PlaceFlag
@onready var remove_flag_audio: AudioStreamPlayer = $RemoveFlag
@onready var explosion_audio: AudioStreamPlayer = $Explosion
@onready var cube_scanner: Area3D = $CubeScanner
@onready var cube_destroyed = preload("res://shared/cube/CubeDestroyed.tscn")
@onready var nearby_mines_label: Label3D = $NearbyMinesLabel
@onready var mine_sprite: Sprite3D = $Mine
@onready var flag_sprite: Sprite3D = $Flag
@onready var top_mesh: MeshInstance3D = $TopMesh

var is_bomb: bool = false
var has_exploded: bool = false
var is_cleared: bool = false
var is_flagged: bool = false

signal game_over
signal cube_was_cleared

func _ready():
	if isLoadingCleared:
		is_cleared = true
		handle_uncleared_secondary_pressed()
	if isLoadingExploded:
		is_bomb = true
		handle_uncleared_pressed()

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		var is_left_click := mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT
		var is_right_click := mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_RIGHT
		if !is_cleared:
			if is_right_click or (is_left_click and event.is_command_or_control_pressed()):
				handle_uncleared_secondary_pressed()
			elif is_left_click:
				handle_uncleared_pressed()
		elif is_left_click:
			handle_cleared_pressed()

func _on_mouse_entered():
	top_mesh.highlight_cube()

func _on_mouse_exited():
	top_mesh.unhighlight_cube()

func handle_uncleared_pressed():
	if !is_flagged:
		reveal_cube(true)
		top_mesh.unhighlight_cube()
		if is_bomb:
			trigger_explosion()

func handle_uncleared_secondary_pressed():
	toggle_flag()

func handle_cleared_pressed():
	cube_scanner.update_cube()
	if cube_scanner.can_auto_clear:
		reveal_cube_audio.play()
		for cube in cube_scanner.overlapping_cubes:
			cube.reveal_cube()
			if cube.is_bomb and cube.is_cleared:
				cube.trigger_explosion()


func reveal_cube(play_sound: bool = false):
	if !is_cleared and !is_flagged:
		if play_sound:
			reveal_cube_audio.play()
		top_mesh.visible = false
		nearby_mines_label.visible = true
		#transform = transform.translated(Vector3(0, -0.1, 0))
		is_cleared = true;
		cube_was_cleared.emit(self)
		cube_scanner.update_cube()
		if is_bomb:
			game_over.emit()
			mine_sprite.visible = true

func trigger_explosion():
	if !has_exploded:
		explosion_audio.play()
		var CubeDestroyed = cube_destroyed.instantiate()
		add_child(CubeDestroyed)
		CubeDestroyed.global_position = Vector3(global_position.x, 0.7, global_position.z)
		top_mesh.visible = false
		flag_sprite.visible = false
		has_exploded = true

func toggle_flag():
	is_flagged = !is_flagged
	flag_sprite.visible = true if is_flagged else false
	if is_flagged:
		place_flag_audio.play()
	else:
		remove_flag_audio.play(0.15)

func remove_flag():
	is_flagged = false
	flag_sprite.visible = false
