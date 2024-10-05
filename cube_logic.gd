extends StaticBody3D

var color1 = Color(1, 0, 0)
var color2 = Color(0, 1, 0)
var color3 = Color(0, 0, 1, 0)
var selectedColor = [color1, color2, color3].pick_random()

func _ready() -> void:
	$MeshInstance3D.mesh.material.albedo_color = selectedColor
