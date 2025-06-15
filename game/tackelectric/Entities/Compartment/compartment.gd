extends Entity
class_name Compartment

# Compartment

@export var mesh : MeshInstance3D = null

var mouseHover := false
var mouseDrag := false

func _ready():
	setMeshColor(Color.GRAY)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LEFT_CLICK"):
		if mouseHover:
			mouseDrag = true
	
	if event.is_action_released("LEFT_CLICK"):
		if mouseDrag:
			mouseDragged()
			mouseDrag = false
			mouseNotHovered()

func mouseDragged():
	print("Compartment: Mouse dragged at : ")


func mouseHovered():
	mouseHover = true
	setMeshColor(Color.WHITE)


func mouseNotHovered():
	if mouseDrag == false:
		mouseHover = false
		setMeshColor(Color.GRAY)


#func mouseDragged():
	#mouseDrag = true
	


func setMeshColor(color:Color):
	if is_instance_valid(mesh):
		var material = mesh.get_active_material(0)
		
		material = material.duplicate()
		mesh.set_surface_override_material(0, material)
		
		material.albedo_color = color

	else:
		print("Compartment: Mesh is not assigned!")
