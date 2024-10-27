extends Area3D
const COLORS: Array[Color] = [
	Color(0, 0, 1),
	Color(0, 0.5, 0),
	Color(1, 0, 0),
	Color(0, 0, 0.5),
	Color(0.3, 0.05, 0),
	Color(0, 0.4, 0.5),
	Color(0, 0, 0),
	Color(0.5, 0.5, 0.5)
]
var Cube: StaticBody3D
var NearbyMinesLabel: Label3D
var overlapping_cubes: Array[Node3D]
var can_auto_clear: bool = false

func _ready() -> void:
	Cube = $".."
	NearbyMinesLabel = $"../NearbyMinesLabel"

func get_nearby_cube_info(nearbyCubes: Array[Node3D]) -> Array[int]:
	var bombs := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_bomb)
	var flags := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_flagged)
	return [bombs.size(), flags.size()]

func update_cube() -> void:
	overlapping_cubes = get_overlapping_bodies()
	var nearby_items := get_nearby_cube_info(overlapping_cubes)
	can_auto_clear = nearby_items[0] == nearby_items[1]
	var nearbyMines := nearby_items[0]
	if Cube.is_cleared:
		if Cube.is_bomb:
			update_label('💣', Color(1, 1, 1))
		else:
			update_label(
				str(nearbyMines) if nearbyMines else '',
				COLORS[clamp(nearbyMines, 1, COLORS.size()) - 1]
			)
		if !nearbyMines:
			for overlapping_cube in overlapping_cubes:
				overlapping_cube.reveal_cube()

func update_label(text: String, color: Color) -> void:
	NearbyMinesLabel.text = text
	NearbyMinesLabel.modulate = color
	NearbyMinesLabel.outline_modulate = color
