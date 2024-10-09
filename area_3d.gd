extends Area3D

func get_nearby_mine_count():
	var count = 0
	var cubes = get_overlapping_bodies()
	for cube in cubes:
		if cube.isBomb:
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
		if $"..".isBomb:
			$"../Label3D".text = '💣'
			for cube in cubes:
				cube.reveal_cube()
	else:
		$"../Label3D".text = nearbyMinesNumber
