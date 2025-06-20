@tool
extends Node3D
class_name Entity

@export var Size := Vector2(1,1)

@export var StartingCoord: Vector2 = Vector2(0, 0): 
		set(newCoord):
			StartingCoord = newCoord
			
			if Engine.is_editor_hint():
				var world_pos = Vector3(
					StartingCoord.x * g.gridSeparation,
					0,  # Keep Y at 0, or adjust if your grid has a specific height
					StartingCoord.y * g.gridSeparation
				)
				
				global_position = world_pos
		get:
			return StartingCoord

enum Direction {
	NORTH = 180,    
	EAST = 90,   
	SOUTH = 0,
	WEST = 270    
}

@export var startingDirection: Direction = Direction.SOUTH: 
	set(newDirection) :
		startingDirection = newDirection
	
		if Engine.is_editor_hint():
			global_rotation_degrees.y = startingDirection
	get:
		return startingDirection


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

# Reapply these in the editor so the position and rotation
# are saved
func _ready():
	if Engine.is_editor_hint():
		StartingCoord = StartingCoord
		startingDirection = startingDirection


func setStartingDirection(value: Direction):
	print("Entity setting starting direction")
	startingDirection = value
	
	#var rotation_radians = deg_to_rad(float(startingDirection))
	
	if Engine.is_editor_hint():
		global_rotation_degrees.y = startingDirection


func get_forward_vector() -> Vector2:
	match startingDirection:
		Direction.NORTH:
			return Vector2(0, 1)
		Direction.EAST:
			return Vector2(1, 0)
		Direction.SOUTH:
			return Vector2(0, -1)
		Direction.WEST:
			return Vector2(-1, 0)
		_:
			return Vector2(0, -1)
