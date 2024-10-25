extends StaticBody3D
@export var mesh1: Mesh
@export var mesh2: Mesh
@export var flatMesh: Mesh
@export var bombMesh: Mesh
@export var radioactiveMesh: Mesh

var is_cleared: bool = false
var is_flagged: bool = false
@export var is_bomb: int = false
var bomb_probability = 0.16

var simulate_gravity = false
var velocity = Vector3.ZERO
var gravity = Vector3.DOWN * 9.8

signal game_over
signal cube_was_cleared

func _ready() -> void:
	# is_bomb = true if (randi() % 100) < (bomb_probability*100) else false
	var selectedMesh = mesh1
	# duplicate meshes and materials 
	$MeshInstance3D.mesh = selectedMesh.duplicate()
	$MeshInstance3D.mesh.material = $MeshInstance3D.get_active_material(0).duplicate()

func _physics_process(delta):
	if simulate_gravity:
		velocity += gravity * delta
		translate(velocity * delta)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
		if event is InputEventMouseButton:
			var mouse_event := event as InputEventMouseButton
			if !is_cleared:
				if event.is_command_or_control_pressed() and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
					toggle_flag()
				elif mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
					if !is_flagged:
						unhighlight_cube()
						reveal_cube()
						if is_bomb:
							animateExplosion()
				elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
					toggle_flag()
			else:
				if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
					if $Area3D.can_auto_clear:
						for cube in $Area3D.cubes:
							cube.reveal_cube()

func reveal_cube():
	if !is_cleared and !is_flagged:
		var newMesh = bombMesh if is_bomb else flatMesh
		$MeshInstance3D.mesh = newMesh
		transform = transform.translated(Vector3(0, -0.1, 0))
		$Label3D.visible = true
		is_cleared = true;
		cube_was_cleared.emit(self)
		if is_bomb:
			game_over.emit()

func toggle_flag():
	is_flagged = !is_flagged
	$Label3D.text = "🚩" if is_flagged else ""

func animateExplosion():
	$MeshInstance3D.mesh = radioactiveMesh
	unhighlight_cube()

func enable_gravity():
	simulate_gravity = true

func _on_mouse_entered():
	if !is_cleared:
		highlight_cube()

func _on_mouse_exited():
	unhighlight_cube()

func highlight_cube():
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		$MeshInstance3D.mesh.material.emission_enabled = true
		$MeshInstance3D.mesh.material.emission = Color(0.3, 0.3, 0.3)

func unhighlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	$MeshInstance3D.mesh.material.emission_enabled = false
