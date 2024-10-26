extends Camera3D

# Camera shake parameters
var shake_intensity: float = 1.0
var shake_decay: float = 0.5
var shaking: bool = false
var has_shaken: bool = false

# Original transform to return to after shaking
var original_transform

func _ready():
	# Save the original transform
	original_transform = global_transform

func _process(delta: float) -> void:
	if shaking:
		# Apply random offset to the camera's position
		var random_offset = Vector3(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		global_transform.origin = original_transform.origin + random_offset
		
		# Reduce the shake intensity over time
		shake_intensity -= shake_decay * delta
		
		# Stop shaking if the intensity is low enough
		if shake_intensity <= 0.0:
			shaking = false
			shake_intensity = 0.0
			# Reset the camera's transform to the original
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
