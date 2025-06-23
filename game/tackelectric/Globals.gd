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
signal level_loaded
signal playMode
signal attractMode
signal winText

func game_won():
	print("Game won!")
	
	emit_signal("winText")
	
	await get_tree().create_timer(5.3).timeout
	resetVariables()
	
	emit_signal("game_is_won")

	#get_tree().reload_current_scene()

func levelLoaded():
	emit_signal("level_loaded")

func startPlayMode():
	emit_signal("playMode")

func startAttractMode():
	emit_signal("attractMode")


func game_over():
	print("Game over!")
	resetVariables()
	
	emit_signal("game_is_over")
	


func resetVariables():
	selectingCompartment = false
