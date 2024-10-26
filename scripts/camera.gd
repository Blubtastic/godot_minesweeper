extends Camera3D

var shake_intensity: float = 1.0
var shake_decay: float = 0.5
var shaking: bool = false
var has_shaken: bool = false
var original_transform

func _ready():
	original_transform = global_transform

func _process(delta: float) -> void:
	if shaking:
		# Apply random offset to the camera's position
		var rand_vector = randf_range(-shake_intensity, shake_intensity)
		var random_offset = Vector3(rand_vector, rand_vector, rand_vector)
		global_transform.origin = original_transform.origin + random_offset
		
		# Reduce the shake intensity over time
		shake_intensity -= shake_decay * delta
		
		if shake_intensity <= 0.0:
			shaking = false
			shake_intensity = 0.0
			global_transform = original_transform

# Function to start the camera shake
func start_shake(intensity: float, decay: float):
	if has_shaken:
		return
	has_shaken = true
	shaking = true
	shake_intensity = intensity
	shake_decay = decay
	# Save the current transform as the original
	original_transform = global_transform
