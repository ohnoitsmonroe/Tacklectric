extends Node3D

@export var mesh : MeshInstance3D = null

var active := false


func _ready():
	setInActive()


func setActive():
	active = true
	setMeshColor(Color.RED)


func setInActive():
	active = false
	setMeshColor(Color.GRAY)


func setMeshColor(color:Color):
	if is_instance_valid(mesh):
		var material = mesh.get_active_material(0)
		
		material = material.duplicate()
		mesh.set_surface_override_material(0, material)
		
		material.albedo_color = color
	else:
		print("Compartment: Mesh is not assigned!")
