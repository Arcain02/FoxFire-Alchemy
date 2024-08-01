extends Node2D

var onFire : bool = false
var spreadable : bool = false
var alreadyFired : bool = false

var overlapping

func _ready():
	$AnimatedSprite2D.play("Default")
	$FireArea.set_deferred("monitorable", false)
	$FireArea/FireCollision.set_deferred("disabled", true)
	$BaseGrass.set_deferred("monitoring", true)
	$BaseGrass/GrassCollision.set_deferred("disabled", false)

func _physics_process(delta):
	pass
	
func _on_base_grass_area_entered(area):
	if area.is_in_group("Fire") and onFire == false and Global.castingFire == true:
		onFire = true
		spreadable = true
		alreadyFired = true
		burnControl()

func isSpreadable():
	return spreadable

func startFire():
	pass

func burnControl():
	$AnimatedSprite2D.play("Fire")
	await get_tree().create_timer(.1).timeout
	
	$BaseGrass.set_deferred("monitoring", false)
	$BaseGrass/GrassCollision.set_deferred("disabled", true)
	$FireArea.set_deferred("monitorable", true)
	$FireArea/FireCollision.set_deferred("disabled", false)

	await get_tree().create_timer(1).timeout
	
	$FireArea.set_deferred("monitorable", false)
	$FireArea/FireCollision.set_deferred("disabled", true)
	$CheckFire.stop()
	onFire = false
	spreadable = false

func _on_check_fire_timeout():
	if $FireDetector.has_overlapping_areas () == true:
		overlapping = $FireDetector.get_overlapping_areas()
		for i in range(overlapping.size()):
			if overlapping[i].has_node("FireCollision") == true and alreadyFired == false:
				alreadyFired = true
				burnControl()
				
		
