@tool
extends Node3D
class_name Entity

@export var Size := Vector2(1,1)
@export var startingDirection := Vector2(0, 1)

@export var startingCoord: Vector2i = Vector2i(0, 0): 
		set = setWorldPositionFromCoordinate

# When a fishing line checks the cell, it will try to find this
# method, then it will check its own script for a matching method
@export var lineContactMethod := ""

# This is the cell in the grid that houses the top
# left quadrant of the entity, if the entity 
# has multiple cells
# otherwise it is just the cell that it is currently on
var anchorCell : Cell = null


signal moveEntity

# Used for the fishing line spawn point
# if this was a longer project then we should 
# do this in a better way
signal spawnLine

func setWorldPositionFromCoordinate(coord:Vector2i):
	startingCoord = coord
	
	var world_pos = Vector3(
		startingCoord.x * g.gridSeparation,
		0,  # Keep Y at 0, or adjust if your grid has a specific height
		startingCoord.y * g.gridSeparation
	)
	
	if Engine.is_editor_hint():
		global_position = world_pos
