extends CharacterBody2D

const MAX_JUMP_FORCE = -600.0       # Maximum jump force
const MIN_JUMP_FORCE = -200.0       # Minimum jump force
const MAX_HORIZONTAL_SPEED = 300.0 # Maximum horizontal speed
const GRAVITY = 800.0              # Gravity force
const JUMP_TIME_LIMIT = 0.5        # Maximum time to charge the jump

var is_jumping = false
var jump_time = 0.0
var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0
var previous_velocity_y = 0.0  # To track vertical velocity change

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Detect the apex of the jump
	if is_jumping and previous_velocity_y < 0 and velocity.y > 0:
		# The velocity has changed from upward to downward
		$AnimatedSprite2D.play("jump part 2")

	# Reduce jump buffer timer
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	# Charge jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		jump_time += delta
		jump_time = clamp(jump_time, 0.0, JUMP_TIME_LIMIT)

	# Trigger jump
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		is_jumping = true
		jump_buffer_timer = jump_buffer_time
		velocity.y = lerp(float(MIN_JUMP_FORCE), float(MAX_JUMP_FORCE), jump_time / JUMP_TIME_LIMIT)
		velocity.x = lerp(0.0, float(MAX_HORIZONTAL_SPEED), jump_time / JUMP_TIME_LIMIT)
		jump_time = 0.0
		$AnimatedSprite2D.play("jump part 1")  # Start jump animation

	# Reset horizontal velocity on landing (only if not in jump buffer)
	if is_on_floor() and is_jumping and jump_buffer_timer <= 0.0:
		is_jumping = false
		velocity.x = 0
		$AnimatedSprite2D.play("idle sitting")  # Play idle animation when landing

	# Store the previous vertical velocity
	previous_velocity_y = velocity.y

	# Move the character
	move_and_slide()
