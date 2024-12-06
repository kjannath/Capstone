extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cat/CharacterBody2D/LoseScreen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn")
