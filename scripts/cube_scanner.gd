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
var overlapping_cubes
var can_auto_clear = false

func get_nearby_cube_data(nearbyCubes: Array[Node3D]) -> Array:
	var bombs := nearbyCubes.filter(func(cube): return true if cube.is_bomb else false)
	var flags := nearbyCubes.filter(func(cube): return true if cube.is_flagged else false)
	return [bombs.size(), flags.size()]

func update_cube():
	overlapping_cubes = get_overlapping_bodies()
	var cubeData = get_nearby_cube_data(overlapping_cubes)
	var nearbyMines = cubeData[0]
	var nearbyFlags = cubeData[1]
	can_auto_clear = true if nearbyMines == nearbyFlags else false
	
	if $"..".is_cleared:
		if nearbyMines == 0:
			for cube in overlapping_cubes:
				cube.reveal_cube()
		if $"..".is_bomb:
			$"../Label3D".text = '💣'
			$"../Label3D".modulate = Color(1, 1, 1)
		else:
			$"../Label3D".text = str(nearbyMines) if nearbyMines > 0 else ''
			var index = nearbyMines - 1 if nearbyMines < colors.size() - 1 else 0
			$"../Label3D".modulate = colors[index]
			$"../Label3D".outline_modulate = colors[index]
