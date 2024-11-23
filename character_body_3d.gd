extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 8
var overlapping_cubes
@onready var hitbox: Area3D = $Area3D
var is_controllable = true

func _physics_process(delta: float) -> void:
	var cubes = get_tree().get_nodes_in_group("cubes")
	overlapping_cubes = hitbox.get_overlapping_bodies()
	for overlapping_cube in overlapping_cubes:
		if overlapping_cube in cubes:
			overlapping_cube.handle_uncleared_pressed()

	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if is_controllable:
		move_and_slide()
