extends Area3D
const colors = [
	Color(0, 0, 1),
	Color(0, 0.5, 0),
	Color(1,0,0),
	Color(0,0,0.5),
	Color(0.5,0.5,0),
	Color(0,0.4,0.5),
	Color(0,0,0),
	Color(0,0,0),
	Color(0,0,0), 
]

func get_nearby_mine_count():
	var count = 0
	var cubes = get_overlapping_bodies()
	for cube in cubes:
		if cube.is_bomb:
			count += 1
	return count

func _physics_process(_delta: float) -> void:
	var nearbyMines = get_nearby_mine_count()
	var nearbyMinesNumber = str(nearbyMines) if nearbyMines > 0 else ''
	var cubes = get_overlapping_bodies()
	if $"..".isRevealed:
		if nearbyMines == 0:
			for cube in cubes:
				cube.reveal_cube()
		if $"..".is_bomb:
			$"../Label3D".text = '💣'
			$"../Label3D".modulate = Color(0,0,0,1)
			for cube in cubes:
				cube.reveal_cube()
	else:
		$"../Label3D".text = nearbyMinesNumber
		$"../Label3D".modulate = colors[nearbyMines-1]
		$"../Label3D".outline_modulate = colors[nearbyMines-1]
