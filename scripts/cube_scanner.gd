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

func update_cube() -> void:
	overlapping_cubes = get_overlapping_bodies()
	var nearby_items: Array[int] = get_nearby_cube_info(overlapping_cubes)
	can_auto_clear = nearby_items[0] == nearby_items[1]
	var nearby_mines: int = nearby_items[0]
	if Cube.is_cleared:
		var nearby_mines_text = str(nearby_mines) if nearby_mines else ''
		var nearby_mines_color = COLORS[clamp(nearby_mines, 1, COLORS.size()) - 1]
		var text = '💣' if Cube.is_bomb else nearby_mines_text
		var color = Color(1, 1, 1) if Cube.is_bomb else nearby_mines_color
		update_label(text, color)
		if !nearby_mines:
			for overlapping_cube in overlapping_cubes:
				overlapping_cube.reveal_cube()

func get_nearby_cube_info(nearbyCubes: Array[Node3D]) -> Array[int]:
	var bombs := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_bomb)
	var flags := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_flagged)
	return [bombs.size(), flags.size()]

func update_label(text: String, color: Color) -> void:
	NearbyMinesLabel.text = text
	NearbyMinesLabel.modulate = color
	NearbyMinesLabel.outline_modulate = color
