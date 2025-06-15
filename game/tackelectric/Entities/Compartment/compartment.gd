extends Entity

# Compartment

@export var mesh : MeshInstance3D = null

var mouseHover := false

func _ready():
	setMeshColor(Color.GRAY)


func mouseHovered():
	mouseHover = true
	setMeshColor(Color.WHITE)


func mouseNotHovered():
	mouseHover = false
	setMeshColor(Color.GRAY)


func setMeshColor(color:Color):
	if is_instance_valid(mesh):
		var material = mesh.get_active_material(0)
		
		material = material.duplicate()
		mesh.set_surface_override_material(0, material)
		
		material.albedo_color = color

	else:
		print("Compartment: Mesh is not assigned!")
