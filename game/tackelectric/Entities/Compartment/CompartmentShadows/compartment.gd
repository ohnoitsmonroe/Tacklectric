@tool
extends Entity
class_name Compartment

# Compartment

@export var mesh : MeshInstance3D = null

@onready var compPos = self.global_position

var mouseHover := false
var selected := false

var mousePos := Vector2(0,0)

var dragDistance := 400

var childEntities := {}

var offsetPos := Vector3(0,0,0)
var moveVector := Vector2(0,0)
var moveTargetPos := Vector2(0,0)

var previewDistance := .1

var moving := false

var mouseInCollider := false

signal sfx_float
signal sfx_place

func _ready():
	if not Engine.is_editor_hint():
		offsetPos = global_position
		setMeshColor(Color.GRAY)
		
		randomize()
		await get_tree().create_timer(randf_range(.1,3)).timeout
		$sway_anim.play("sway", )



func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("left_click"):
			if moving == false:
				if mouseHover:
					if g.selectingCompartment == false:
						g.selectingCompartment = true
				
						selected = true
						mousePos = get_viewport().get_mouse_position()
						print("Compartment setting mouse pos: " + str(mousePos))
						
						# Set the move target pos to be the current
						# position before its moved
						if is_instance_valid(anchorCell):
							moveTargetPos = anchorCell.gridPos
							
		elif event.is_action_released("left_click"):
			if selected:
				selected = false
				mouseNotHovered()
				
				var newMousePos = get_viewport().get_mouse_position()
				setMoveDirection(newMousePos)
				
				moveComp()


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if is_instance_valid(anchorCell):
			if global_position != anchorCell.global_position:
				global_position = lerp(global_position, anchorCell.global_position, .5)
		
		if not moving:	
			$MeshInstance3D.global_position = lerp($MeshInstance3D.global_position, offsetPos, .5)
			$ChildEntities.global_position = lerp($ChildEntities.global_position, offsetPos, .5)
			$model.global_position  = lerp($model.global_position, offsetPos, .5)
		if selected:
			var newMousePos = get_viewport().get_mouse_position()
			setMoveDirection(newMousePos)


func setMoveDirection(newMousePos):
	if is_instance_valid(anchorCell):
		# The current gridPos of the cell
		var startingCellPos = anchorCell.gridPos
		
		var netPos = mousePos - newMousePos
		
		var xAxisMovement := true
		
		# This is what will be added to the startingCellPos
		# for the targetPos
		var offsetCellPos = Vector2(0,0)
		
		# Horizontal movement if there is a bigger abs(x)
		if abs(netPos.x) > abs(netPos.y):
			netPos = Vector2(netPos.x, 0)
			xAxisMovement = true
		# Otherwise horizontal movement
		else:
			netPos = Vector2(0, netPos.y)
			xAxisMovement = false
		
		offsetCellPos = round(netPos / Vector2(dragDistance, dragDistance/2))
		
		# This is the position of the cell you want to move to
		var targetCellPos = startingCellPos - offsetCellPos
		
		#print("Compartment: TargetCellPos: " + str(targetCellPos))
		
		var validMove := true
		
		if get_parent() is Grid:
			var cellsToCheckCount := 0
			
			var lastValidMovePos = startingCellPos
			
			if xAxisMovement:
				cellsToCheckCount = targetCellPos.x - startingCellPos.x
				
				for cell in abs(cellsToCheckCount):
					var cellToCheck = Vector2(startingCellPos.x + cell, startingCellPos.y)
					var targetMove = get_parent().checkEntityMovePos(self, cellToCheck)
					
					if targetMove == false:
						validMove = false
						print("Compartment: Invalid move at : " + str(cellToCheck))
					# Set this as the last valid cell to check
					else:
						lastValidMovePos = cellToCheck
			else:
				cellsToCheckCount = targetCellPos.y - startingCellPos.y
				
				for cell in abs(cellsToCheckCount):
					var cellToCheck = Vector2(startingCellPos.x, startingCellPos.y + (cell*sign(cellsToCheckCount)))
					var targetMove = get_parent().checkEntityMovePos(self, cellToCheck)
					
					if targetMove == false:
						validMove = false
						#print("Compartment: Invalid move at : " + str(cellToCheck))


			
			if validMove:
				#print("Compartment: Valid Move at: " + str(targetCellPos))
				if get_parent().checkEntityMovePos(self, targetCellPos):
					var targetCell = get_parent().getCell(targetCellPos)
					if is_instance_valid(targetCell):
						if offsetPos != targetCell.global_position:
							emit_signal("sfx_float")
			
						offsetPos = targetCell.global_position
						
						# This is the position that the compartment will be moved in
						moveTargetPos = targetCellPos
						
						
				
		
			#elif lastValidMovePos.distance_to(targetCellPos) <= 2:
				#if get_parent().checkEntityMovePos(self, lastValidMovePos):
					#var targetCell = get_parent().getCell(lastValidMovePos)
					#if is_instance_valid(targetCell):
						#offsetPos = targetCell.global_position
						#
						## This is the position that the compartment will be moved in
						#moveTargetPos = lastValidMovePos

# This signal will be connected to the grid 
# when it is made
func moveComp():
	emit_signal("sfx_place")
	$place_anim.play("place")
	
	moving = true
	
	var tween = get_tree().create_tween()
	tween.tween_property($Shadow, "global_position", offsetPos, .1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($MeshInstance3D, "global_position", offsetPos, .1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($ChildEntities, "global_position", offsetPos, .1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($model, "global_position", offsetPos, .1).set_trans(Tween.TRANS_CUBIC)

	await tween.finished

	global_position = offsetPos
	$MeshInstance3D.position = Vector3.ZERO
	$ChildEntities.position = Vector3.ZERO
	$Shadow.position = Vector3.ZERO
	$model.position = Vector3.ZERO
	
	# Only move the compartment if the target cell isn't
	# the same pos as the current pos
	if is_instance_valid(anchorCell):
		if moveTargetPos != anchorCell.gridPos:
			emit_signal("moveEntity", self, moveTargetPos)
			
			if is_instance_valid(get_tree()):
				await get_tree().create_timer(.01).timeout


	moving = false

	# cull the children
	cullChildren()
	
	selected = false
	offsetPos = global_position
	
	g.selectingCompartment = false
	
	if mouseInCollider:
		mouseHovered()


func cullChildren():
	for child in get_children():
		if child is Entity:
			if not child.is_in_group("inCompartment"):
				child.queue_free()


func mouseHovered():
	mouseInCollider = true
	
	if g.selectingCompartment == false:
		if selected == false:
			mouseHover = true
			setMeshColor(Color.WHITE)


func mouseNotHovered():
	mouseInCollider = false
	
	if selected == false:
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
