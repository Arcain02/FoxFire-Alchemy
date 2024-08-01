extends Node2D

var introPlayed : int = 0 # 0 is unplayed, 1 is currently playing, 2 is already played, 3 is the dialouge after the letter

func _ready():
	$Player/Camera2D/BookMenu.hide()
	$Letter.hide()
	checkingWhereFrom()
	checkRock()
	Global.currentScene = "Forest"
	$Player.cameraLimits()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and introPlayed == 1:
		$Letter.hide()
		$Player/Camera2D/UI.show()
		introPlayed = 2
		Global.inMenu = false
		Global.canEnterMenu = true
	
	if (Global.mushroomCollected == true and Global.birchCollected == true) and Global.diaPlaying == false:
		Global.diaPlaying = true
		$EndingAction.action()
	elif Global.endingReady == true:
		$Player.checkForEnding()

func intro():
	if introPlayed == 0:
		introPlayed = 1
		$Player/Camera2D/UI.hide()
		$Letter.show()
		Global.canEnterMenu = false
		Global.inMenu = true

# Checks where the player came from so that we can decide whether or not to play the intro sequence and also the location
# that they appear in.
func checkingWhereFrom():
	if Global.currentScene == "Main Menu":
		$Player.position.x = 176
		$Player.position.y = 432
		intro()
	elif Global.currentScene == "CaveOne":
		$Player.position.x = 360
		$Player.position.y = 80

func checkRock():
	# Checks left rock
	if Global.rockLeft == true:
		$RockLeftSprite.set_deferred("visible", true)
		$LeftWater/LeftColl.set_deferred("disabled", true)
	else:
		$RockLeftSprite.set_deferred("visible", false)
		$LeftWater/LeftColl.set_deferred("disabled", false)
	# Checks right rock
	if Global.rockRight == true:
		$RockRightSprite.set_deferred("visible", true)
		$RightWater/RightColl.set_deferred("disabled", true)
	else:
		$RockRightSprite.set_deferred("visible", false)
		$RightWater/RightColl.set_deferred("visible", false)

# SIGNALS

# Designed to disable the log once it enters this area.
func _on_area_log_area_entered(area):
	if area.has_node("ForceColl"):
		$Log/HitBox.set_deferred("disabled", true)
		$Log/ForceDec.set_deferred("monitoring", false)

# Left Rock
func _on_rock_detection_left_body_entered(body):
	if body.is_in_group("Rock"):
		body.water_rock()
		$RockLeftSprite.set_deferred("visible", true)
		$LeftWater/LeftColl.set_deferred("disabled", true)
		Global.rockLeft = true

# Right rock
func _on_rock_detection_right_body_entered(body):
	if body.is_in_group("Rock"):
		body.water_rock()
		$RockRightSprite.set_deferred("visible", true)
		$RightWater/RightColl.set_deferred("disabled", true)
		Global.rockRight = true
	

# Only play this if they try and re-enter the home
func _on_actionable_home_area_entered(area):
	if introPlayed == 2:
		$ActionableHome.action()

func _on_actionable_birch_area_entered(area):
	if Global.birchCollected == false:
		Global.birchCollected = true
		$ActionableBirch.action()

# Changes scene to the cavern
func _on_transfer_scene_area_entered(area):
	get_tree().change_scene_to_file.bind("res://Scenes/CaveOne.tscn").call_deferred()
