extends Node3D
const CubeScene = preload("res://cube.tscn")
const GRID_SIZE = 10
const CUBE_DISTANCE = 1.0

func _ready() -> void:
	spawn_grid()

func spawn_grid():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var cube_instance = CubeScene.instantiate()
			var position = Vector3(i * CUBE_DISTANCE, 0, j * CUBE_DISTANCE)
			cube_instance.transform.origin = position
			add_child(cube_instance)
