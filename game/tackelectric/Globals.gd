extends Node

var camera = null
var game = null
var music = null
var currentScene : PackedScene = null
var levelDict = {}
var levelList:Array[PackedScene]


@export var gridSeparation := .52
@export var lineHeight := .25

var selectingCompartment := false



# Global signals so they can be triggered from multiple entities
signal game_is_won
signal game_is_over


func game_won():
	print("Game won!")

	await get_tree().create_timer(5.3).timeout
	resetVariables()
	
	emit_signal("game_is_won")

	#get_tree().reload_current_scene()


func game_over():
	print("Game over!")


	await get_tree().create_timer(1.5).timeout
	resetVariables()
	
	emit_signal("game_is_over")
	#get_tree().reload_current_scene()

func resetVariables():
	selectingCompartment = false
