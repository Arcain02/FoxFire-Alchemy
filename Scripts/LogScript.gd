extends CharacterBody2D

var input_dir
var moving : bool = false
var canMove : bool = false

var overlapping

func _physics_process(delta):
	move_and_collide(velocity)

func _on_force_dec_area_entered(area):
	
	if area.is_in_group("Force") and Global.castingForce == true:
			move()

func move():
	input_dir = Vector2.ZERO
	match Global.currentDir:
		"up":
			input_dir = Vector2(0, -1)
		"down":
			input_dir = Vector2(0, 1)
		"left":
			input_dir = Vector2(-1, 0)
		"right":
			input_dir = Vector2(1, 0)
	
	if input_dir:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + input_dir * 16, 1)
			tween.tween_callback(move_false)
			
func move_false():
	moving = false
