extends Node
class_name Entity

@export var StartingCoord := Vector2(0,0)
@export var Size := Vector2(1,1)

# This is the cell in the grid that houses the top
# left quadrant of the entity, if the entity 
# has multiple cells
# otherwise it is just the cell that it is currently on
var anchorCell : Cell = null

signal moveEntity
