extends RigidBody3D

var emission_amount = 3

func _ready() -> void:
	$MeshInstance3D.mesh.material.emission_energy_multiplier = emission_amount

func _physics_process(delta: float) -> void:
	if is_visible_in_tree():
		emission_amount -= 5*delta
		if emission_amount >= 0:
			$MeshInstance3D.mesh.material.emission_energy_multiplier = emission_amount
		else:
			emission_amount = 0
