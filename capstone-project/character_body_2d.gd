extends CharacterBody2D

const MAX_JUMP_FORCE = -400.0
const MIN_JUMP_FORCE = -150.0
const MAX_HORIZONTAL_SPEED = 300.0
const GRAVITY = 800.0
const JUMP_TIME_LIMIT = 0.5

var is_jumping = false
var jump_time = 0.0
var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0
var previous_velocity_y = 0.0  # Track vertical velocity to detect the apex

@onready var jump_power_bar = $"/root/Node2D/CanvasLayer/ProgressBar"  # Corrected path
@onready var animated_sprite = $"/root/Node2D/Cat/Sprite/AnimatedSprite"  # Corrected path

func _physics_process(_delta: float) -> void:  # Suppress unused delta warning
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * _delta

	# Detect the apex of the jump (vertex)
	if is_jumping and previous_velocity_y < 0 and velocity.y > 0:
		$AnimatedSprite2D.play("jump part 2")  # Play landing animation at the apex

	# Reduce jump buffer timer
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= _delta

	# Charge jump while holding spacebar
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		jump_time += _delta
		jump_time = clamp(jump_time, 0.0, JUMP_TIME_LIMIT)
		if jump_power_bar:
			jump_power_bar.value = jump_time  # Update jump power bar value
		$AnimatedSprite2D.play("charging stance")  # Play charging animation

	# Trigger jump when spacebar is released
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		is_jumping = true
		jump_buffer_timer = jump_buffer_time
		velocity.y = lerp(float(MIN_JUMP_FORCE), float(MAX_JUMP_FORCE), jump_time / JUMP_TIME_LIMIT)
		velocity.x = lerp(0.0, float(MAX_HORIZONTAL_SPEED), jump_time / JUMP_TIME_LIMIT)
		jump_time = 0.0
		if jump_power_bar:
			jump_power_bar.value = jump_time  # Reset power bar
		$AnimatedSprite2D.play("jump part 1")  # Play jump animation

	# Reset horizontal velocity and animation on landing
	if is_on_floor() and is_jumping and jump_buffer_timer <= 0.0:
		is_jumping = false
		velocity.x = 0
		$AnimatedSprite2D.play("idle sitting")  # Play idle animation when landing

	# Save previous vertical velocity to detect the apex
	previous_velocity_y = velocity.y

	# Move the character
	move_and_slide()
