extends StaticBody3D

@onready var CubeDestroyed = preload("res://shared/cube/CubeDestroyed.tscn")
@export var flatMesh: Mesh
@export var bombMesh: Mesh
@export var is_bomb := false


@onready var CubeMesh: MeshInstance3D = $Mesh
@onready var CubeScanner: Area3D = $CubeScanner
@onready var NearbyMinesLabel: Label3D = $NearbyMinesLabel
@onready var RevealCubeAudio: AudioStreamPlayer = $RevealCube
@onready var PlaceFlagAudio: AudioStreamPlayer = $PlaceFlag
@onready var RemoveFlagAudio: AudioStreamPlayer = $RemoveFlag
@onready var HighlightCubeAudio: AudioStreamPlayer = $HighlightCube
@onready var ExplosionAudio: AudioStreamPlayer = $Explosion
@onready var mine_sprite: Sprite3D = $Mine
@onready var flag_sprite: Sprite3D = $Flag


var is_cleared := false
var is_flagged := false
var is_hovering := false
var simulate_gravity := false
var velocity := Vector3.ZERO
var gravity := Vector3.DOWN * 9.8
var original_albedo: Color
var bright_albedo : Color = Color(0.8, 0.8, 0.8)
var start_material

signal game_over
signal cube_was_cleared

func _ready() -> void:
	CubeMesh.mesh = CubeMesh.mesh.duplicate()
	CubeMesh.mesh.material = CubeMesh.get_active_material(0).duplicate()
	start_material = CubeMesh.mesh.material
	original_albedo = start_material.albedo_color

func _physics_process(delta):
	if simulate_gravity:
		velocity += gravity * delta
		translate(velocity * delta)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		var is_left_click := mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT
		var is_right_click := mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_RIGHT
		if !is_cleared:
			if is_right_click or (is_left_click and event.is_command_or_control_pressed()):
				toggle_flag()
			elif is_left_click and !is_flagged:
				reveal_cube(true)
				unhighlight_cube()
				if is_bomb:
					trigger_explosion()
		elif is_left_click:
			CubeScanner.update_cube()
			if CubeScanner.can_auto_clear:
				RevealCubeAudio.play()
				for cube in CubeScanner.overlapping_cubes:
					cube.reveal_cube()
					if cube.is_bomb and cube.is_cleared:
						cube.trigger_explosion()

func _on_mouse_entered():
	if !is_cleared:
		highlight_cube()

func _on_mouse_exited():
	unhighlight_cube()

func reveal_cube(play_sound: bool = false):
	if !is_cleared and !is_flagged:
		if play_sound:
			RevealCubeAudio.play()
		CubeMesh.mesh = bombMesh if is_bomb else flatMesh
		NearbyMinesLabel.visible = true
		transform = transform.translated(Vector3(0, -0.1, 0))
		is_cleared = true;
		cube_was_cleared.emit(self)
		CubeScanner.update_cube()
		if is_bomb:
			trigger_game_over()
			mine_sprite.visible = true

func trigger_game_over():
	game_over.emit()
	ExplosionAudio.play()
	unhighlight_cube()

func trigger_explosion():
	var cube_destroyed = CubeDestroyed.instantiate()
	add_child(cube_destroyed)
	cube_destroyed.global_position = Vector3(global_position.x, 0.7, global_position.z)
	CubeMesh.visible = false
	mine_sprite.visible = false
	flag_sprite.visible = false

func toggle_flag():
	is_flagged = !is_flagged
	flag_sprite.visible = true if is_flagged else false
	if is_flagged:
		PlaceFlagAudio.play()
	else:
		RemoveFlagAudio.play(0.15)

func remove_flag():
	is_flagged = false
	flag_sprite.visible = false

func enable_gravity():
	#simulate_gravity = true
	pass

func highlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	start_material.albedo_color  = bright_albedo
	HighlightCubeAudio.play()

func unhighlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	start_material.albedo_color = original_albedo
