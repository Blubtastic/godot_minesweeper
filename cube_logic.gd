extends StaticBody3D
@export var mesh1: Mesh
@export var mesh2: Mesh
@export var flatMesh: Mesh

var color1 = Color(1, 0, 0)
var color2 = Color(0, 1, 0)
var color3 = Color(0, 0, 1, 0)
var selectedColor = [color1, color2, color3].pick_random()
var isTranslated = false;

func _ready() -> void:
	var selectedMesh: Mesh = [mesh1, mesh2].pick_random()
	$MeshInstance3D.mesh = selectedMesh

#func _unhandled_input(event):
	#if event is InputEventMouseButton:
		#print("Mouse:", event.global_position)
		#print($CollisionShape3D.global_position)
#
#func _on_mouse_entered() -> void:
	#if !isTranslated:
		#$MeshInstance3D.mesh = flatMesh
		#transform = transform.translated(Vector3(0,-0.1,0))
		#isTranslated = true;

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if !isTranslated:
			$MeshInstance3D.mesh = flatMesh
			transform = transform.translated(Vector3(0,-0.1,0))
			isTranslated = true;

func _physics_process(delta: float) -> void:
	var results = $ShapeCast3D.collision_result
	$Label3D.text = str(results.size())
