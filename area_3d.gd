extends Area3D

func get_nearby_nodes():
	var count = 0
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.isBomb:
			count += 1
	return count

func _physics_process(delta: float) -> void:
	if $"..".isBomb:
		$"../Label3D".text = '💣'
	else:
		$"../Label3D".text = str(get_nearby_nodes())
