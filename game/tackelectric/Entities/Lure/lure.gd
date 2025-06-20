extends Entity


# Lure

func _ready():
	await get_tree().create_timer(.1).timeout
	# Match the direction to the starting direction
	var angle = (startingDirection * Vector2(-1, 1)).angle()
	#print("Lure: STarting angle: " + str(startingDirection))
	var newRotation = rad_to_deg(angle)
	$MeshInstance3D.rotation_degrees.y = newRotation
