extends StaticBody3D

@export var mesh: Mesh
@export var flatMesh: Mesh
@export var bombMesh: Mesh
@export var radioactiveMesh: Mesh
@export var is_bomb := false
@onready var CubeMesh: MeshInstance3D = $CubeMesh
@onready var CubeScanner: Area3D = $CubeScanner
@onready var NearbyMinesLabel: Label3D = $NearbyMinesLabel
var is_cleared := false
var is_flagged := false
var simulate_gravity := false
var velocity := Vector3.ZERO
var gravity := Vector3.DOWN * 9.8
signal game_over
signal cube_was_cleared

func _ready() -> void:
	CubeMesh.mesh = mesh.duplicate()
	CubeMesh.mesh.material = CubeMesh.get_active_material(0).duplicate()
	CubeMesh.mesh.material.emission = Color(0.3, 0.3, 0.3)

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
				reveal_cube()
				unhighlight_cube()
		elif is_left_click:
			CubeScanner.update_cube()
			if CubeScanner.can_auto_clear:
				for cube in CubeScanner.overlapping_cubes:
					cube.reveal_cube()

func _on_mouse_entered():
	if !is_cleared:
		highlight_cube()

func _on_mouse_exited():
	unhighlight_cube()

func reveal_cube():
	if !is_cleared and !is_flagged:
		$RevealCube.play()
		CubeMesh.mesh = bombMesh if is_bomb else flatMesh
		NearbyMinesLabel.visible = true
		transform = transform.translated(Vector3(0, -0.1, 0))
		is_cleared = true;
		cube_was_cleared.emit(self)
		CubeScanner.update_cube()
		if is_bomb:
			game_over.emit()
			animateExplosion()

func animateExplosion():
	CubeMesh.mesh = radioactiveMesh
	unhighlight_cube()

func toggle_flag():
	is_flagged = !is_flagged
	NearbyMinesLabel.text = "🚩" if is_flagged else ""

func enable_gravity():
	simulate_gravity = true

func highlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	CubeMesh.mesh.material.emission_enabled = true

func unhighlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	CubeMesh.mesh.material.emission_enabled = false
