extends Node3D

@export var mesh : Node3D = null
@export var offColor : Color

var active := false


func _ready():
	setInActive()


func setActive():
	if active == false:
		active = true
		$anim.play("light")


func setRed():
	setMeshColor(Color.RED)


func setInActive():
	active = false
	setMeshColor(offColor)
	$OmniLight3D.visible = false



func setMeshColor(color:Color):
	if is_instance_valid(mesh):
		var material = mesh.get_active_material(0)
		
		material = material.duplicate()
		mesh.set_surface_override_material(0, material)
		
		material.albedo_color = color
	else:
		print("Compartment: Mesh is not assigned!")
