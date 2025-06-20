@tool
extends Entity
class_name Compartment

# Compartment

@export var mesh : MeshInstance3D = null

@onready var compPos = self.global_position

var mouseHover := false
var mouseDrag := false
var selected := false

var childEntities := {}


func _ready():
	if not Engine.is_editor_hint():
		setMeshColor(Color.GRAY)


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("left_click"):
			if mouseHover:
				selected = !selected
				#print("Compartment Location: ", compPos)
				
		if selected:
			if event.is_action_pressed("move_left"):
				moveComp(-1, 0)
			elif event.is_action_pressed("move_right"):
				moveComp(1, 0)
			elif event.is_action_pressed("move_up"):
				moveComp(0, -1)
			elif event.is_action_pressed("move_down"):
				moveComp(0, 1)


# This signal will be connected to the grid 
# when it is made
func moveComp(x,y):
	emit_signal("moveEntity", self, Vector2(x,y))


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


func addChildEntity(childRef:Entity, startingCompartmentCoord:Vector2, gridPos:Vector2, grid:Grid):
	var newChild = childRef.duplicate()
	$ChildEntities.add_child(newChild)
	newChild.StartingCoord = startingCompartmentCoord
	
	# Set a reference to the child based on the gridPos
	# This will be changed whenever the compartment is moved so
	# there is always an updated position
	childEntities[gridPos] = newChild

	var cell = grid.getCell(gridPos + startingCompartmentCoord).global_position
	if is_instance_valid(cell):
		newChild.global_position = cell.global_position
