extends Node3D

# Tacklebox model

func _ready() -> void:
	g.game_is_over.connect(closeAndReOpen)
	g.level_loaded.connect(closeAndReOpen)


func closeAndReOpen():
	close()
	await get_tree().create_timer(1).timeout
	open()


func open():
	$anim.play("open")


func close():
	$anim.play("close")
