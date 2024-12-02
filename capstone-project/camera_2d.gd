extends Camera2D

const FIXED_VERTICAL_POSITION = 10  # Set the vertical position you want the camera to stay at

func _process(delta):
	# Update the camera's position to follow the cat horizontally
	global_position.x = get_parent().global_position.x
	# Lock the vertical position to a constant value
	global_position.y = FIXED_VERTICAL_POSITION
