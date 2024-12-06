extends Control

func _ready():
	$Roti/AnimatedSprite2D.play("default")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn")
