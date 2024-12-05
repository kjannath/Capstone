extends CharacterBody2D

const MAX_JUMP_FORCE = -400.0
const MIN_JUMP_FORCE = -150.0
const MAX_HORIZONTAL_SPEED = 400.0
const GRAVITY = 700.0
const JUMP_TIME_LIMIT = 1.5

var is_jumping = false
var jump_time = 0.0
var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0
var previous_velocity_y = 0.0  # Track vertical velocity to detect the apex

var meow_sounds = [
	preload ("res://roti sounds/Roti8(SMALL).mp3"),
	preload ("res://roti sounds/Roti9(SMALL).mp3"),
	preload ("res://roti sounds/Roti3(SMALL).mp3"),
	preload ("res://roti sounds/Roti10(SMALLISH).mp3"),
	preload ("res://roti sounds/Roti2(MEDIUM).mp3"),
	preload ("res://roti sounds/Roti6(MEDIUM).mp3"),
	preload ("res://roti sounds/Roti10(SMALLISH).mp3"),
	preload ("res://roti sounds/Roti7(LONG).mp3")
]

var has_played_death_sound = false  # Flag to prevent repeated execution


@onready var jump_sound = $JumpSound
@onready var play_again_button = $Camera2D/Control

func _ready():
	play_again_button.visible = false

func get_jump_time() -> float:
	return jump_time
	
func get_jump_time_limit() -> float:
	return JUMP_TIME_LIMIT


func _physics_process(_delta: float) -> void:
	
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
		$AnimatedSprite2D.play("charging stance")  # Play charging animation

	# Trigger jump when spacebar is released
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		is_jumping = true
		jump_buffer_timer = jump_buffer_time
		velocity.y = lerp(float(MIN_JUMP_FORCE), float(MAX_JUMP_FORCE), jump_time / JUMP_TIME_LIMIT)
		velocity.x = lerp(0.0, float(MAX_HORIZONTAL_SPEED), jump_time / JUMP_TIME_LIMIT)
		
		# Play jump animation
		$AnimatedSprite2D.play("jump part 1")
		
		#Play jump sound
		var random_meow = meow_sounds[randi() % meow_sounds.size()]
		jump_sound.stream = random_meow
		jump_sound.play()
		
		#Reset jump time for next jump
		jump_time = 0.0

	# Reset horizontal velocity and animation on landing
	if is_on_floor() and is_jumping and jump_buffer_timer <= 0.0:
		is_jumping = false
		velocity.x = 0
		$AnimatedSprite2D.play("idle sitting")  # Play idle animation when landing

	# Save previous vertical velocity to detect the apex
	previous_velocity_y = velocity.y
	
	if position.y > 150 and not has_played_death_sound:
		$DeathTimer.start()  # Start the buffer timer and then load death screen
		has_played_death_sound = true
		
	# Move the character
	move_and_slide()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_death_timer_timeout() -> void:
	play_again_button.visible = true
	
	if randi() % 2 == 0:
		$DeathSound1.play()
	else:
		$DeathSound2.play()
