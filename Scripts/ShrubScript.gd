extends RigidBody2D

var onFire : bool = false
var alreadyFired : bool = false

var overlapping

func _ready():
	$AnimatedSprite2D.play("Base")


func _on_fire_area_area_entered(area):
	if area.is_in_group("Fire") and onFire == false and Global.castingFire == true:
		onFire = true
		alreadyFired = true
		burnControl()
		
func burnControl():
	$AnimatedSprite2D.play("Burn")
	await get_tree().create_timer(.5).timeout
	
	$FireArea.set_deferred("monitoring", false)
	$HitBox.set_deferred("disabled", true)
	$FireCounter.stop()
	
func _on_fire_counter_timeout():
	if $FireArea.has_overlapping_areas() == true:
		overlapping = $FireArea.get_overlapping_areas()
		for i in range(overlapping.size()):
			if overlapping[i].has_node("FireCollision") == true and alreadyFired == false:
				alreadyFired = true
				burnControl()
