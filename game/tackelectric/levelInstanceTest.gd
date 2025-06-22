extends Node

@export var tacklebox : PackedScene = null

func _ready():
	add_child(tacklebox.instantiate())
