extends Node3D


func _ready() -> void:
	g.cast.connect(cast)


func cast():
	$anim.play("cast")
