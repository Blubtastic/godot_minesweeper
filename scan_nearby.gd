extends Area3D
const colors = [
	Color(0, 0, 1),
	Color(0, 0.5, 0),
	Color(1,0,0),
	Color(0,0,0.5),
	Color(0.3, 0.05, 0),
	Color(0,0.4,0.5),
	Color(0,0,0),
	Color(0.5,0.5,0.5)
]

var cubes
var can_auto_clear = false

func get_nearby_mine_count():
	var count = 0
	var cubes = get_overlapping_bodies()
	for cube in cubes:
		if cube.is_bomb:
			count += 1
	return count

func get_nearby_flag_count():
	var count = 0
	var cubes = get_overlapping_bodies()
	for cube in cubes:
		if cube.is_flagged:
			count += 1
	return count

func _physics_process(_delta: float) -> void:
	var nearbyMines = get_nearby_mine_count()
	var nearbyFlags = get_nearby_flag_count()
	can_auto_clear = true if nearbyMines == nearbyFlags else false
	var nearbyMinesNumber = str(nearbyMines) if nearbyMines > 0 else ''
	cubes = get_overlapping_bodies()
	if $"..".is_cleared:
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
			var index = nearbyMines - 1 if nearbyMines < colors.size()-1 else 0
			$"../Label3D".modulate = colors[index]
			$"../Label3D".outline_modulate = colors[index]
