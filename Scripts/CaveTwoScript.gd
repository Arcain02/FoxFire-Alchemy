extends Node2D
var inSignArea : bool = false

func _ready():
	Global.currentScene = "CaveTwo"
	$Player.cameraLimits()

func _physics_process(delta):
	if (Global.mushroomCollected == true and Global.birchCollected == true) and Global.diaPlaying == false:
		Global.diaPlaying = true
		$EndingAction.action()
	elif Global.endingReady == true:
		$Player.checkForEnding()

func _input(event):
	if ((Input.is_action_just_pressed("ui_accept") and Global.diaPlaying == false) and inSignArea == true) and Global.currentScene == "CaveTwo":
		$Actionable.action()
		
# SIGNALS
func _on_actionable_area_entered(area): # Sign actionable entered
	inSignArea = true

func _on_actionable_area_exited(area): # Sign actionable exited
	inSignArea = false

# Will stop the rocks from moving after they reach this area so that weird physics interactions don't happen with the tileset.
func _on_first_rocks_body_entered(body):
	if body.is_in_group("Rock"):
		body.stopDetecting()

func _on_ladder_area_area_entered(area):
	get_tree().change_scene_to_file.bind("res://Scenes/CaveOne.tscn").call_deferred()

func _on_actionable_mushroom_area_entered(area):
	if Global.mushroomCollected == false:
		Global.mushroomCollected = true
		$ActionableMushroom.action()
