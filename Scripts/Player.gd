extends CharacterBody2D

const SPEED = 70.0

var currentDir : String
var isCasting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	isCasting = false
	$AnimatedSprite.play("Forward (Idle)")
	$AnimationPlayer.play("Reset")
	$Spells.set_frame_and_progress(0, 0)
	$Spells.visible = false
	$ForceArea.monitorable = false
	$Camera2D/BookMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# I don't want the player moving as their casting. This will also make it feel slightly more impactful
	# and will be among the only times the player cant move since they can't die either (no combat).
	if isCasting == false and Global.inMenu == false:
		player_movement(delta)
		if Input.is_action_just_pressed("Fire"): # This button is the key 'E'
			fireControl()
		elif Input.is_action_just_pressed("Force"): # This button is the key 'R'
			forceControl()
		elif Input.is_action_just_pressed("Menu") and Global.canEnterMenu == true: # This button is tab
			checkBooklet()
	elif Global.inMenu == true and Global.canEnterMenu == true:
		if Input.is_action_just_pressed("Menu") or Input.is_action_just_pressed("ui_cancel"):
			checkBooklet()

# All this function does is control player movement. This was created in order to make the _process function
# appear cleaner, since it will get cluttered very quickly as development continues.
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		currentDir = "right"
		Global.currentDir = "right"
		
		velocity.x = SPEED * 1
		velocity.y = 0
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Right (Walking)")
	
	elif Input.is_action_pressed("ui_left"):
		currentDir = "left"
		Global.currentDir = "left"
		
		velocity.x = SPEED * -1
		velocity.y = 0
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Right (Walking)")
	
	elif Input.is_action_pressed("ui_down"):
		currentDir = "down"
		Global.currentDir = "down"
		
		velocity.x = 0
		velocity.y = SPEED * 1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Forward (Walking)")
	
	elif Input.is_action_pressed("ui_up"):
		currentDir = "up"
		Global.currentDir = "up"
		
		velocity.x = 0
		velocity.y = SPEED * -1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Back (Walking)")
	else:
		velocity.x = 0
		velocity.y = 0
		match currentDir:
			"right":
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("Right (Idle)")
			"left":
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("Right (Idle)")
			"up":
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("Back (Idle)")
			"down":
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("Forward (Idle)")
		
	move_and_slide()

# Called when the player casts Fire
func fireControl():
	Global.castingFire = true
	isCasting = true
	
	# In order to avoid having two different areas for the left and right, we roate it 
	# Wait for the Activate animations to finish before playing the idle animation for the player.
	# Want to ensure that it actually works
	match currentDir:
		"left":
			$Spells.set_position(Vector2(($Marker2D.position.x - 11), ($Marker2D.position.y + 8)))
			$AnimationPlayer.play("(Activate) Left")
			await $AnimationPlayer.animation_finished
			
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Right (Idle)")
		"right":
			$Spells.set_position(Vector2(($Marker2D.position.x + 11), ($Marker2D.position.y + 8)))
			$AnimationPlayer.play("(Activate) Right")
			await $AnimationPlayer.animation_finished
			
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Right (Idle)")
		"up":
			$Spells.set_position(Vector2($Marker2D.position.x, ($Marker2D.position.y - 16)))
			$AnimationPlayer.play("(Activate) FireTop")
			await $AnimationPlayer.animation_finished
			
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Back (Idle)")
		"down":
			$Spells.set_position(Vector2($Marker2D.position.x, ($Marker2D.position.y + 24)))
			$AnimationPlayer.play("Activate (Bottom)")
			await $AnimationPlayer.animation_finished
		
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Forward (Idle)")
	
	$Spells.visible = true
	$Spells.set_frame_and_progress(0, 0)
	$Spells.play("Fire")

	# Start playing animation here for the fire when added
	
	await get_tree().create_timer(.7).timeout
	
	$AnimationPlayer.play("Reset")
	
	$Spells.visible = false
	Global.castingFire = false
	isCasting = false

# Called when the player casts force
func forceControl():
	Global.castingForce = true
	isCasting = true
	
	# Changes the direction of the force to match the direction that the player is facing
	match currentDir:
		"up":
			$Spells.set_position(Vector2($Marker2D.position.x, ($Marker2D.position.y - 16)))
			$AnimationPlayer.play("(Activate) Force Top")
			$Spells.set_rotation_degrees(0)
			
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Back (Idle)")
		"down":
			$Spells.set_position(Vector2($Marker2D.position.x, ($Marker2D.position.y + 24)))
			$AnimationPlayer.play("(Activate) Force Bottom")
			$Spells.set_rotation_degrees(180)
			
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Forward (Idle)")
		"left":
			$Spells.set_position(Vector2(($Marker2D.position.x -11), ($Marker2D.position.y + 8)))
			$AnimationPlayer.play("(Activate) Force Left")
			$Spells.set_rotation_degrees(270.0)
			
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Right (Idle)")
		"right":
			$Spells.set_position(Vector2(($Marker2D.position.x + 11), ($Marker2D.position.y + 8)))
			$AnimationPlayer.play("(Activate) Force Right")
			$Spells.set_rotation_degrees(90.0)
			
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Right (Idle)")
			
	
	$Spells.visible = true
	$Spells.set_frame_and_progress(0, 0)
	$Spells.play("Force")
	
	# Start playing animation for force here when created
	
	await get_tree().create_timer(.7).timeout
	
	$AnimationPlayer.play("Reset")
	
	$Spells.set_rotation_degrees(0.0)
	Global.castingForce = false
	isCasting = false

func cameraLimits():
	match Global.currentScene:
		"Forest":
			$Camera2D.limit_left = 0
			$Camera2D.limit_top = 0
			$Camera2D.limit_right = 960
			$Camera2D.limit_bottom = 544
		"CaveOne":
			$Camera2D.limit_left = 0
			$Camera2D.limit_top = 144
			$Camera2D.limit_right = 384
			$Camera2D.limit_bottom = 544
		"CaveTwo":
			$Camera2D.limit_left = 0
			$Camera2D.limit_top = 0
			$Camera2D.limit_right = 512
			$Camera2D.limit_bottom = 432

# Handles the controls for checking the booklet
func checkBooklet():
	# SHOWS the booklet and reveals the other UI contents
	if Global.inMenu == false:
		$Camera2D/BookMenu.show()
		$Camera2D/UI.hide()

		# May need to set the position of the book here if it doesn't follow the player as intended.
		
		# Whether or not these are shown is the same value (true or false) of what was collected.
		$Camera2D/BookMenu/Control/BirchCollected.visible = Global.birchCollected
		$Camera2D/BookMenu/Control/MushroomCollected.visible = Global.mushroomCollected
		
		Global.inMenu = true # Sets this variable to show we're in the menu now
	
	# HIDES the contents of the booklet
	elif Global.inMenu == true:
		$Camera2D/BookMenu.hide()
		$Camera2D/UI.show()
		
		Global.inMenu = false # Resetting the menu now that they exitted

# Will be called and used to check for if the player has collected both ingredients whenever they 
func checkForEnding():
	if Global.mushroomCollected == true and Global.birchCollected == true:
		Global.canEnterMenu = false
		Global.inMenu = true
		$AnimationPlayer.play("Ending")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file.bind("res://Scenes/Ending.tscn").call_deferred()
