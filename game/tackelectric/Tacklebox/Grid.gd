extends Node3D

# Grid

# This will be the current level grid that can be 
# queried for movement and interaction between entities

@export var width := 8
@export var height := 5

# Grid Separation is multiplied by the cell's position
#@export var gridSeparation := 1.5

@export var setupEntities : SetupEntities = null

@export var cellRef : PackedScene = null

# The cells dictionary saves reference to each cell node
# by a Vector2 of its coordinate
var cells := {}

func _ready():
	createGrid()
	addEntities(setupEntities)


func createGrid():
	for y in height:
		for x in width:
			var newCell = cellRef.instantiate()
			add_child(newCell)
			
			var cellPos = Vector2(x,y)
			
			cells[cellPos] = newCell
			
			newCell.position = Vector3(cellPos.x * g.gridSeparation, global_position.y, cellPos.y * g.gridSeparation)


# Add all the objects from the setup objects to the grid
func addEntities(entitiesToAdd):
	if is_instance_valid(entitiesToAdd):
		for entity in entitiesToAdd.get_children():
			if entity is Entity:
				var newEntity = entity.duplicate()
				var gridPos = entity.StartingCoord
				
				if cells.has(gridPos):
					var cell = cells[gridPos]
					
					if cell is Cell:
						cells[gridPos].addEntity(newEntity)
				
				else:
					print("Grid: Cell grid does not have cell at " + str(gridPos))
	else:
		print("Grid: SetupEntities is unassigned!")
