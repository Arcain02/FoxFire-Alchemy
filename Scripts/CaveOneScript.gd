extends Node2D

var ladderDiaPlayed : bool = false

func _ready():
	whereComeFrom()
	Global.currentScene = "CaveOne"
	$Player.cameraLimits()

func _physics_process(delta):
	pass

func _on_actionable_ladder_area_entered(area):
	if ladderDiaPlayed == false:
		ladderDiaPlayed = true
		$ActionableLadder.action()

# Checks which scene the player came from so we know where to "drop them off"
func whereComeFrom():
	if Global.currentScene == "Forest":
		$Player.position.x = 168
		$Player.position.y = 528
	elif Global.currentScene == "CaveTwo":
		$Player.position.x = 184
		$Player.position.y = 304


# SIGNALS

# Switches back to the forest
func _on_outside_area_entered(area):
	get_tree().change_scene_to_file.bind("res://Scenes/Forest.tscn").call_deferred()

func _on_ladder_area_area_entered(area):
	get_tree().change_scene_to_file.bind("res://Scenes/CaveTwo.tscn").call_deferred()
