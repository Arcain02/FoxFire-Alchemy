extends Node2D

func _ready():
	Global.currentScene = "Main Menu"

func _on_start_butt_pressed():
		get_tree().change_scene_to_file("res://Scenes/Forest.tscn")
