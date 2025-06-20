extends Node3D
class_name LineSegment

# The scale the line has to reach to be a grid square

@export var gridScaleLength := 13.5

@onready var mesh = $MeshInstance3D

var canContinueScale := true

signal extendedToNewCell


func _physics_process(delta: float) -> void:
	if canContinueScale:
		mesh.scale.y += .5
	
		# Emit a signal for the fishing rod when the 
		# length reaches the length of a cell
		if int(mesh.scale.y) % int(gridScaleLength) == 0:
			emit_signal("extendedToNewCell")
	


func setAngle(direction:Vector2):
	var angle = (direction * Vector2(-1, 1)).angle()
	var newRotation = rad_to_deg(angle)
	mesh.rotation_degrees.y = newRotation
	
	# Move the mesh back towards the start of the cell
	mesh.position += Vector3((direction.x * (g.gridSeparation / 2.0)), 0, direction.y * (g.gridSeparation / 2.0))


func stopScale():
	canContinueScale = false
