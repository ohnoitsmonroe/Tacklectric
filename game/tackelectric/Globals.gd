extends Node

var camera = null
var game = null

@export var gridSeparation := .52
@export var lineHeight := .25

var selectingCompartment := false



# Global signals so they can be triggered from multiple entities
signal game_is_won
signal game_is_over


func game_won():
	print("Game won!")
	emit_signal("game_is_won")

	await get_tree().create_timer(5.3).timeout
	resetVariables()
	
	get_tree().reload_current_scene()


func game_over():
	print("Game over!")

	emit_signal("game_is_over")
	await get_tree().create_timer(1.5).timeout
	resetVariables()
	get_tree().reload_current_scene()

func resetVariables():
	selectingCompartment = false
