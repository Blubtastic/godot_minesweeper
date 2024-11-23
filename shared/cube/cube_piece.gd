extends RigidBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	$MeshInstance3D.mesh.material.emission_energy_multiplier = 10

func _physics_process(delta: float) -> void:
	$MeshInstance3D.mesh.material.emission_energy_multiplier -= 0.7*delta
