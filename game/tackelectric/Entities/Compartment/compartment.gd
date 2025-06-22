@tool
extends Entity
class_name Compartment

# Compartment

@export var mesh : MeshInstance3D = null

@onready var compPos = self.global_position

var mouseHover := false
var selected := false

var mousePos := Vector2(0,0)

var dragDistance := 20 

var childEntities := {}

var offsetPos := Vector3(0,0,0)
var moveVector := Vector2(0,0)

var previewDistance := .1


func _ready():
	if not Engine.is_editor_hint():
		setMeshColor(Color.GRAY)


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("left_click"):
			if mouseHover:
				selected = true
				mousePos = get_viewport().get_mouse_position()
		
		elif event.is_action_released("left_click"):
			if selected:
				var newMousePos = get_viewport().get_mouse_position()
				setMoveDirection(newMousePos)
				moveComp(moveVector.x, moveVector.y)


func _process(delta: float) -> void:
	$MeshInstance3D.position = lerp($MeshInstance3D.position, offsetPos, .5)
	$ChildEntities.position = lerp($MeshInstance3D.position, offsetPos, .2)
	if selected:
		var newMousePos = get_viewport().get_mouse_position()
		setMoveDirection(newMousePos)


func setMoveDirection(newMousePos):
	# Move Right
	var netPos = mousePos - newMousePos
	if abs(netPos.x) > abs(netPos.y):
		if newMousePos.x > mousePos.x + dragDistance:
			offsetPos = Vector3(previewDistance, 0, 0)
			moveVector = Vector2(1, 0)
			
		# Move Left
		elif newMousePos.x < mousePos.x - dragDistance:
			offsetPos = Vector3(-previewDistance, 0, 0)
			moveVector = Vector2(-1, 0)
			
		# Move Up
		elif newMousePos.y > mousePos.y + dragDistance:
			offsetPos = Vector3(0, 0, previewDistance)
			moveVector = Vector2(0, 1)
			
		# Move Down
		elif newMousePos.y < mousePos.y - dragDistance:
			offsetPos = Vector3(0, 0, -previewDistance)
			moveVector = Vector2(0, -1)
	else:
			# Move Up
			if newMousePos.y > mousePos.y + dragDistance:
				offsetPos = Vector3(0, 0, 0.15)
				moveVector = Vector2(0, 1)
				
			# Move Down
			elif newMousePos.y < mousePos.y - dragDistance:
				offsetPos = Vector3(0, 0, -.15)
				moveVector = Vector2(0, -1)
				
			# Move Right
			elif newMousePos.x > mousePos.x + dragDistance:
				offsetPos = Vector3(.15, 0, 0)
				moveVector = Vector2(1, 0)
				
			# Move Left
			elif newMousePos.x < mousePos.x - dragDistance:
				offsetPos = Vector3(-.15, 0, 0)
				moveVector = Vector2(-1, 0)


# This signal will be connected to the grid 
# when it is made
func moveComp(x,y):
	selected = false
	offsetPos = Vector3(0,0,0)

	emit_signal("moveEntity", self, Vector2(x,y))
	cullChildren()


func cullChildren():
	for child in get_children():
		if child is Entity:
			if not child.is_in_group("inCompartment"):
				child.queue_free()

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


func getChildEntity(gridPos:Vector2):
	if not Engine.is_editor_hint():
		if childEntities.has(gridPos):
			return childEntities[gridPos]
		
		return null


func addChildEntity(childRef:Entity, startingCompartmentCoord:Vector2, gridPos:Vector2, grid:Grid):
	if not Engine.is_editor_hint():
		var newChild = childRef
		$ChildEntities.add_child(newChild)
		newChild.StartingCoord = startingCompartmentCoord
		
		# Set a reference to the child based on the gridPos
		# This will be changed whenever the compartment is moved so
		# there is always an updated position
		childEntities[gridPos + startingCompartmentCoord] = newChild

		var cell = grid.getCell(gridPos + startingCompartmentCoord)
		
		if is_instance_valid(cell):
			newChild.global_position = cell.global_position
	
	cullChildren()

# Reset all the references to the child entity position
# after being moved to a new location
func setChildEntityPositions(newStartingCoord:Vector2):
	if not Engine.is_editor_hint():
		childEntities = {}
		for child in $ChildEntities.get_children():
			childEntities[newStartingCoord + child.StartingCoord] = child
