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

var cubes
var can_auto_clear = false

func get_nearby_cube_data(nearbyCubes: Array[Node3D]):
	var bombCount = 0
	var flagCount = 0
	for cube in nearbyCubes:
		if cube.is_bomb:
			bombCount += 1
		if cube.is_flagged:
			flagCount += 1
	return [bombCount, flagCount]

func _physics_process(_delta: float) -> void:
	cubes = get_overlapping_bodies()
	var cubeData = get_nearby_cube_data(cubes)
	var nearbyMines = cubeData[0]
	var nearbyFlags = cubeData[1]
	can_auto_clear = true if nearbyMines == nearbyFlags else false
	var nearbyMinesNumber = str(nearbyMines) if nearbyMines > 0 else ''
	
	# TODO: optimize, all surrounding cube labels are refreshed every frame.
	if $"..".is_cleared:
		if nearbyMines == 0:
			for cube in cubes:
				cube.reveal_cube()
		if $"..".is_bomb:
			$"../Label3D".text = '💣'
			$"../Label3D".modulate = Color(1, 1, 1)
			for cube in cubes:
				cube.reveal_cube()
		else:
			$"../Label3D".text = nearbyMinesNumber
			var index = nearbyMines - 1 if nearbyMines < colors.size() - 1 else 0
			$"../Label3D".modulate = colors[index]
			$"../Label3D".outline_modulate = colors[index]
