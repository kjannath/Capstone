extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameMusic.play()
	$WinScreen.visible = false
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == $Cat/CharacterBody2D:
		print("win")
		$WinScreen.visible = true
		$YaySound.play()
