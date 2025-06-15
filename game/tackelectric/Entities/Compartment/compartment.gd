extends Entity
class_name Compartment

# Compartment

@export var mesh : MeshInstance3D = null

@onready var compPos = self.global_position

var mouseHover := false
var mouseDrag := false
var selected := false


func _ready():
	setMeshColor(Color.GRAY)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if mouseHover:
			selected = !selected
			print("Compartment Location: ", compPos)
			
	if selected:
		if event.is_action_pressed("move_left"):
			moveComp(-1 * g.gridSeparation, 0, 0 * g.gridSeparation)
		elif event.is_action_pressed("move_right"):
			moveComp(1 * g.gridSeparation, 0, 0 * g.gridSeparation)
		elif event.is_action_pressed("move_up"):
			moveComp(0 * g.gridSeparation, 0, -1 * g.gridSeparation)
		elif event.is_action_pressed("move_down"):
			moveComp(0 * g.gridSeparation, 0, 1 * g.gridSeparation)


func moveComp(x, y, z):
	var newPos = compPos + Vector3(x, y, z)
	newPos = newPos.clamp(Vector3(0, 0, 0), Vector3(10.5, 0, 6))
	print("New pos: ", newPos)
	self.global_position = newPos
	compPos = newPos


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
