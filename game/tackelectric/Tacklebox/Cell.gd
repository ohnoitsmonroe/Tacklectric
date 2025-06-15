extends Node3D
class_name Cell

@export var held_entity : Entity = null
@export var held_compartment : Compartment = null

func addEntity(entity):
	add_child(entity)
	held_entity = entity
	print("Cell: Added entity")

func removeEntity():
	if is_instance_valid(held_entity):
		held_entity.queue_free()
	
	held_entity = null
