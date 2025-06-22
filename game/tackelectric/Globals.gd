extends Node

var camera = null

@export var gridSeparation := .52

# Global signals so they can be triggered from multiple entities
signal game_is_won
signal game_is_over


func game_won():
	print("Game won!")
	emit_signal("game_is_won")
	get_tree().reload_current_scene()


func game_over():
	print("Game over!")
	emit_signal("game_is_over")
	get_tree().reload_current_scene()
