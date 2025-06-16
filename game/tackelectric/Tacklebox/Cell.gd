extends Node3D
class_name Cell

@export var held_entity : Entity = null

var gridPos := Vector2(0,0)

func setEntity(entity):
	held_entity = entity
	print("Cell: Added entity")

func removeEntity():
	held_entity = null

func getEntity():
	return held_entity
