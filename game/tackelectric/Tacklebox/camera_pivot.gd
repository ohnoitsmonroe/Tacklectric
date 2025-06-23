extends Node3D


# Camera Pivot

func _ready():
	g.attractMode.connect(attractMode)
	g.playMode.connect(playMode)

	attractMode()

func playMode():
	$anim.play("play")

func attractMode():
	$anim.play("attract")
