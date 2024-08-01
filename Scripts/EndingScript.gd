extends Node2D

var first : bool = true

func _ready():
	$Letter/Text.text = "Thank you so much! After drinking your potion, the pain was gone before the sun even set. You're a lifesaver!"
	$ThankYou.hide()
	$Letter.show()
	first = true

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and first == true:
		$Letter.hide()
		$ThankYou.show()
		first = false
	elif Input.is_action_just_pressed("ui_accept") and first == false:
		get_tree().change_scene_to_file.bind("res://Scenes/main_menu.tscn").call_deferred()
