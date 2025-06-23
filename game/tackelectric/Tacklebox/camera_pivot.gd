extends Node3D


# Camera Pivot

func _ready():
	attractMode()

func playMode():
	$anim.play("play")

func attractMode():
	$anim.play("attract")
