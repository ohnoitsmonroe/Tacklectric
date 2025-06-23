extends Node3D

# Music stabs

signal game_won
signal game_over


func _ready():
	g.winText.connect(game_is_won)
	g.game_is_over.connect(game_is_over)


func game_is_won():
	emit_signal("game_won")


func game_is_over():
	emit_signal("game_over")
