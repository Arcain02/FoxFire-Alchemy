extends Control

func playBook():
	$AnimationPlayer.set_speed_scale(1.0)
	$AnimationPlayer.play("Summon")
	
func backBook():
	$AnimationPlayer.set_speed_scale(-1.0)
	$AnimationPlayer.play("Summon")
