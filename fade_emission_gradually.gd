extends MeshInstance3D

var emission_amount = 1

func _ready() -> void:
	mesh.material.emission_energy_multiplier = emission_amount

func _physics_process(delta: float) -> void:
	if is_visible_in_tree():
		print("VISIBLE")
		emission_amount -= 0.4*delta
		if emission_amount >= 0:
			mesh.material.emission_energy_multiplier = emission_amount
		else:
			emission_amount = 0
