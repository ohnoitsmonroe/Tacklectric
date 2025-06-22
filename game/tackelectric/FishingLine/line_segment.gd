extends Node3D
class_name LineSegment

# The scale the line has to reach to be a grid square

@export var gridScaleLength := 10

@onready var mesh = $MeshInstance3D

var canContinueScale := true

signal extendedToNewCell


func _physics_process(delta: float) -> void:
	if canContinueScale:
		mesh.scale.y += 2.1
	

func setAngle(direction:Vector2):
	var angle = (direction * Vector2(-1, 1)).angle()
	var newRotation = rad_to_deg(angle)
	mesh.rotation_degrees.y = newRotation
	
	# Move the mesh back towards the start of the cell
	mesh.position += Vector3((direction.x * (g.gridSeparation)), 0, direction.y * (g.gridSeparation))


func stopScale():
	canContinueScale = false


func _on_timer_timeout() -> void:
	emit_signal("extendedToNewCell")
	
