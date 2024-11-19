extends Node3D

@onready var debris: CPUParticles3D = $Debris
@onready var smoke: CPUParticles3D = $Smoke
@onready var fire: CPUParticles3D = $Fire

func _ready():
	explode()

func explode():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
