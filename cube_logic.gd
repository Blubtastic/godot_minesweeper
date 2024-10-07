extends StaticBody3D
@export var mesh1: Mesh
@export var mesh2: Mesh
@export var mesh3: Mesh

var color1 = Color(1, 0, 0)
var color2 = Color(0, 1, 0)
var color3 = Color(0, 0, 1, 0)
var selectedColor = [color1, color2, color3].pick_random()

func _ready() -> void:
	var selectedMesh: Mesh = [mesh1, mesh2, mesh3].pick_random()
	$MeshInstance3D.mesh = selectedMesh
