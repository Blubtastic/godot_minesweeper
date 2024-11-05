extends Area3D

func _physics_process(_delta: float) -> void:
	for o in get_overlapping_bodies():
		if o is RigidBody3D:
			var force = (o.global_position - global_position).normalized()
			force *= 4
			o.apply_central_impulse(force)


func _on_timer_timeout() -> void:
	queue_free()
