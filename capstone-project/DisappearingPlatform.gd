extends Node2D

@export var invisible_threshold: float = 0.1  # Opacity below which collisions are disabled

func _ready():
	# Start the fade cycle animation
	$Sprite2D/AnimationPlayer.play("Fade")

func _process(_delta):
	# Check the current opacity and disable collision if the platform is nearly invisible
	var current_opacity = $Sprite2D.modulate.a
	if current_opacity < invisible_threshold:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
