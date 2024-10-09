extends StaticBody3D
@export var mesh1: Mesh
@export var mesh2: Mesh
@export var flatMesh: Mesh
@export var bombMesh: Mesh

var isTranslated: bool
var isBomb: int
var selectedMesh: Mesh

func _ready() -> void:
	isTranslated = false;
	isBomb = randi() % 2
	selectedMesh = [mesh1, mesh2][isBomb]
	
	# duplicate meshes and materials 
	$MeshInstance3D.mesh = selectedMesh.duplicate()
	$MeshInstance3D.mesh.material = $MeshInstance3D.get_active_material(0).duplicate()
	
	# hide stuff
	$Label3D.visible = false
	$MeshInstance3D.mesh.material.emission_enabled = false

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		# turn into "revealed" cube
		if !isTranslated:
			if isBomb:
				$MeshInstance3D.mesh = bombMesh
			else:
				$MeshInstance3D.mesh = flatMesh
			transform = transform.translated(Vector3(0,-0.1,0))
			isTranslated = true;
			$Label3D.visible = true


func _on_mouse_entered() -> void:
	if !isTranslated:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		$MeshInstance3D.mesh.material.emission_enabled = true
		$MeshInstance3D.mesh.material.emission = Color(0.3,0.3,0.3)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	$MeshInstance3D.mesh.material.emission_enabled = false
