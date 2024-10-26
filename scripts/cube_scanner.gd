extends Area3D
const colors = [
	Color(0, 0, 1),
	Color(0, 0.5, 0),
	Color(1, 0, 0),
	Color(0, 0, 0.5),
	Color(0.3, 0.05, 0),
	Color(0, 0.4, 0.5),
	Color(0, 0, 0),
	Color(0.5, 0.5, 0.5)
]
var Cube
var NearbyMinesLabel
var overlapping_cubes
var can_auto_clear = false

func _ready():
	Cube = $".."
	NearbyMinesLabel = $"../NearbyMinesLabel"

func get_nearby_cube_info(nearbyCubes: Array[Node3D]) -> Array:
	var bombs := nearbyCubes.filter(func(nearbyCube): return true if nearbyCube.is_bomb else false)
	var flags := nearbyCubes.filter(func(nearbyCube): return true if nearbyCube.is_flagged else false)
	return [bombs.size(), flags.size()]

func update_cube():
	overlapping_cubes = get_overlapping_bodies()
	var cubeData = get_nearby_cube_info(overlapping_cubes)
	var nearbyMines = cubeData[0]
	var nearbyFlags = cubeData[1]
	can_auto_clear = true if nearbyMines == nearbyFlags else false
	
	if Cube.is_cleared:
		if Cube.is_bomb:
			update_label('💣', Color(1, 1, 1))
		else:
			var label_text = str(nearbyMines) if bool(nearbyMines) else ''
			var color_index = nearbyMines - 1 if nearbyMines < colors.size() - 1 else 0
			update_label(label_text, colors[color_index])
		if nearbyMines == 0:
			for overlapping_cube in overlapping_cubes:
				overlapping_cube.reveal_cube()

func update_label(text, color):
	NearbyMinesLabel.text = text
	NearbyMinesLabel.modulate = color
	NearbyMinesLabel.outline_modulate = color
