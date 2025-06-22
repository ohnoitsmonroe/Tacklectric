extends Node3D
class_name FishingLine

@export var lineSegmentRef : PackedScene = null

var startingCoord := Vector2(0,0)

var currentCoord := Vector2(0,0)

var currentDirection := Vector2(1,0)

var grid : Grid

var lineActive := false

var currentSegment : LineSegment = null

signal cast


# Called from tacklebox or something when its added
func init(newGrid:Grid, newStartingCoord:Vector2):
	grid = newGrid
	startingCoord = newStartingCoord
	currentCoord = startingCoord


func _ready():
	await get_tree().create_timer(.01).timeout
	iterateLine()


func iterateLine():
	lineActive = true

	while lineActive:
		# Wait for the line to extend the length of a cell
		if is_instance_valid(currentSegment):
			await currentSegment.extendedToNewCell
		
		# Get the target grid entity, and then see what it is
		var targetPos = currentCoord + currentDirection
		var targetCell = grid.getCell(targetPos)

		if is_instance_valid(targetCell):

			# Add a new segment if there isn't a current one
			if !is_instance_valid(currentSegment):
				addLineSegment(currentDirection)
			
			# Redefine the target position if it was changed
			currentCoord = targetPos
			
			# Check for a line contact method from
			# the cell's entity, like a lure's redirect
			# or a fish head's completing function
			
			var targetEntity = targetCell.getEntity()
			
			if is_instance_valid(targetEntity):
				# But first check if the entity is a compartment
				# and if so, set the entity to the compartment's
				# child entity
				if targetEntity is Compartment:
					var childEntity = targetEntity.getChildEntity(targetPos)
					
					if is_instance_valid(childEntity):
						targetEntity = childEntity
			
				if "lineContactMethod" in targetEntity:
					if is_instance_valid(currentSegment):
						await currentSegment.extendedToNewCell
					
					if has_method(targetEntity.lineContactMethod):
						call(targetEntity.lineContactMethod, targetEntity)

		else:
			if is_instance_valid(currentSegment):
				await currentSegment.extendedToNewCell

			# Stop when it hits the edge
			if is_instance_valid(currentSegment):
				currentSegment.stopScale()
				
			lineActive = false
			queue_free()


func addLineSegment(direction:Vector2):
	if is_instance_valid(grid):
		var lineSegment = lineSegmentRef.instantiate()
		add_child(lineSegment)
		
		var cell = grid.getCell(currentCoord + direction)
		
		if is_instance_valid(cell):
			lineSegment.global_position = Vector3(cell.global_position.x, g.lineHeight, cell.global_position.z)
			lineSegment.setAngle(currentDirection)
			currentSegment = lineSegment


# These are all functions called by entities:

func redirect(_entity):
	if is_instance_valid(_entity):
		if "startingDirection" in _entity:
						
			var entityDirection = _entity.get_forward_vector()
			currentDirection = entityDirection * Vector2(1,-1)
						
			# Wait for the segment to extend across the cell
			if is_instance_valid(currentSegment):
				await currentSegment.extendedToNewCell
			
			# Clear the segment reference 
			# so a new one will be spawned
			currentSegment.stopScale()
			currentSegment = null

# When the line hits the fish
func catchFish(_entity):
	# Wait for the segment to extend across the cell
	if is_instance_valid(currentSegment):
		await currentSegment.extendedToNewCell

	lineActive = false
	
	g.game_won()


# When the line hits a wall
func endLine(_entity):
	if is_instance_valid(currentSegment):
		await currentSegment.extendedToNewCell

	# Stop when it hits the edge
	if is_instance_valid(currentSegment):
		currentSegment.stopScale()
		
	lineActive = false
	queue_free()
