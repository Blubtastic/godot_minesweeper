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
	$MeshInstance3D.mesh = selectedMesh
	$Label3D.visible = false

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		# turn into "revealed" cube
		if !isTranslated:
			if isBomb:
				$MeshInstance3D.mesh = bombMesh
			else:
				$MeshInstance3D.mesh = flatMesh
			transform = transform.translated(Vector3(0,-0.1,0))
			isTranslated = true;
			$Label3D.visible = true
