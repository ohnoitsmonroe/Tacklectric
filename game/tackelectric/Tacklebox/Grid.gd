extends Node3D
class_name Grid

# Grid

# This will be the current level grid that can be 
# queried for movement and interaction between entities

@export var width := 8
@export var height := 5

# Grid Separation is multiplied by the cell's position
#@export var gridSeparation := 1.5

@export var setupEntities : SetupEntities = null

@export var referenceGrid : Node3D = null

@export var cellRef : PackedScene = null

@export var lineRef : PackedScene = null

var currentLine = null


# The cells dictionary saves reference to each cell node
# by a Vector2 of its coordinate
var cells := {}

func _ready():
	clearReferenceGrid()
	createGrid()
	await get_tree().create_timer(.1).timeout
	addEntitiesFromSetup()


func clearReferenceGrid():
	if is_instance_valid(referenceGrid):
		referenceGrid.queue_free()
		referenceGrid = null


func createGrid():
	for y in height:
		for x in width:
			
			var newCell = cellRef.instantiate()
			add_child(newCell)
			
			var cellPos = Vector2(x,y)
			
			cells[cellPos] = newCell
			
			newCell.position = Vector3(cellPos.x * g.gridSeparation, global_position.y, cellPos.y * g.gridSeparation)
			newCell.gridPos = cellPos


# Add all the objects from the setup objects to the grid
func addEntitiesFromSetup():
	if is_instance_valid(setupEntities):
		for entity in setupEntities.get_children():
			if entity is Entity:
				var newEntity = entity.duplicate()
				var gridPos = entity.StartingCoord
								
				if cells.has(gridPos):
					var cell = cells[gridPos]
					
					if cell is Cell:
						cell.setEntity(newEntity)
						add_child(newEntity)
						
						# Connect the moveEntity signal
						newEntity.moveEntity.connect(moveEntity)
						
						# Connect the spawnline signal
						newEntity.spawnLine.connect(spawnLine)
						
						setEntityAtCell(newEntity, cell)
						
						# Setup any child entities of compartments
						if entity is Compartment:
							if entity.get_children().size() > 0:
								for childEntity in entity.get_children():
									if childEntity is Entity:
										newEntity.addChildEntity(childEntity.duplicate(), childEntity.StartingCoord, cell.gridPos, self)
						
						# Set the additional cells as being occupied
						# if it's a multi-cell entity
						if newEntity.Size != Vector2.ONE:
							for y in newEntity.Size.y:
								for x in newEntity.Size.x:
									var anchorCell = newEntity.anchorCell
									
									if is_instance_valid(anchorCell):
										var cellPos = anchorCell.gridPos
										setCellEntity(cellPos + Vector2(x, y), newEntity)
								
				else:
					print("Grid: Cell grid does not have cell at " + str(gridPos))
		
		setupEntities.queue_free()
		setupEntities = null
		
	else:
		print("Grid: SetupEntities is unassigned!")


# Connected to an entities moveEntity signal when it is added from Setup
func moveEntity(entity:Entity, direction:Vector2):
	var entitySize := entity.Size
	
	if is_instance_valid(entity.anchorCell):
		var currentPos = entity.anchorCell.gridPos
		var targetPos = currentPos + direction
		
		var cellsOpen := true
		
		var targetCells = []
		var currentCells = []
		
		# Get all the cells that are currently occupied by the entity
		# Then get all the cells that would be occupied by the entity in
		# its target pos
		for y in entitySize.y:
			for x in entitySize.x:
				targetCells.append(getCell(targetPos + Vector2(x,y)))
				currentCells.append(getCell(currentPos + Vector2(x,y)))
		
		# Check all the target cells, and see if they are:
		# 1. In the grid as a valid cell
		# 2. Are open and empty
		# 3. If they are occupied, make sure that the entity occupying
		# isn't the current one
		for cell in targetCells:
			if cell != null:
				if !checkOpenCell(cell.gridPos):
					if getCellHeldEntity(cell.gridPos) != entity:
						cellsOpen = false
						continue
			else:
				cellsOpen = false
				continue
		
		# Move the entity and update the current and target cells
		if cellsOpen:
			# Clear all the current cells
			for cell in currentCells:
				removeCellEntity(cell.gridPos)
			
			# Set all the target cell's references
			for cell in targetCells:
				setCellEntity(cell.gridPos, entity)
			
			# Move the entity
			var targetCell = getCell(targetPos)
			setEntityAtCell(entity, targetCell)


# This just functions for 1x1 entities right now, where anything
# with bigger sizes will need to update the additional cells in
# another function
# We may want to change this, for now I'm just gonna leave it
func setEntityAtCell(entity:Entity, cell:Cell):
	entity.global_position = cell.global_position
	
	# Set the anchorCell
	entity.anchorCell = cell
	
	# Set the entity's held cell
	cell.setEntity(entity)
	
	# Update the child entities if the entity is a compartment
	if entity is Compartment:
		entity.setChildEntityPositions(cell.gridPos)


func spawnLine(cellPos:Vector2):
	if lineRef != null:
		var newLine = lineRef.instantiate()
		
		add_child(newLine)
		currentLine = newLine
		newLine.init(self, cellPos)


func getCell(cellPos:Vector2):
	if cells.has(cellPos):
		return cells[cellPos]
	
	return null


func getCellHeldEntity(cellPos:Vector2):
	if cells.has(cellPos):
		return cells[cellPos].getEntity()
	
	return null


func checkOpenCell(cellPos:Vector2):
	if cells.has(cellPos):
		if cells[cellPos].getEntity() == null:
			return true
	
	return false


func removeCellEntity(cellPos:Vector2):
	if cells.has(cellPos):
		cells[cellPos].removeEntity()


func setCellEntity(cellPos:Vector2, entity:Entity):
	if cells.has(cellPos):
		cells[cellPos].setEntity(entity)
	
