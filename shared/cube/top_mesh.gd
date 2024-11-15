extends MeshInstance3D

@onready var HighlightCubeAudio: AudioStreamPlayer = $"../HighlightCube"
var original_albedo: Color
var bright_albedo : Color = Color(0.8, 0.8, 0.8)

func _ready() -> void:
	mesh = mesh.duplicate()
	mesh.material = get_active_material(0).duplicate()
	original_albedo = mesh.material.albedo_color

func highlight_cube():
	if visible:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		mesh.material.albedo_color  = bright_albedo
		HighlightCubeAudio.play()

func unhighlight_cube():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mesh.material.albedo_color = original_albedo
