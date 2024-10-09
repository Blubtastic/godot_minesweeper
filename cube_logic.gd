extends StaticBody3D
@export var mesh1: Mesh
@export var mesh2: Mesh
@export var flatMesh: Mesh
@export var bombMesh: Mesh
@export var radioactiveMesh: Mesh

var isRevealed: bool = false
var isBomb: int

var simulate_gravity = false
var velocity = Vector3.ZERO
var gravity = Vector3.DOWN * 9.8

signal game_over

func _ready() -> void:
	isBomb = randi() % 2
	var selectedMesh = [mesh1, mesh2][isBomb]
	
	# duplicate meshes and materials 
	$MeshInstance3D.mesh = selectedMesh.duplicate()
	$MeshInstance3D.mesh.material = $MeshInstance3D.get_active_material(0).duplicate()

func _process(delta):
	if simulate_gravity:
		velocity += gravity * delta
		translate(velocity * delta)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if !isRevealed:
		if event is InputEventMouseButton:
			unhighlight_cube()
			reveal_cube()
			if isBomb:
				animateExplosion()

func reveal_cube():
	if !isRevealed:
		var newMesh = bombMesh if isBomb else flatMesh
		$MeshInstance3D.mesh = newMesh
		transform = transform.translated(Vector3(0, -0.1, 0))
		$Label3D.visible = true
		isRevealed = true;
		if isBomb:
			game_over.emit()

func animateExplosion():
	$MeshInstance3D.mesh = radioactiveMesh
	unhighlight_cube()

func enable_gravity():
	simulate_gravity = true

func _on_mouse_entered():
	if !isRevealed:
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
