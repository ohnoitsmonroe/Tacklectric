extends Node3D

# Tacklebox model

var is_open := false

func _ready() -> void:
	g.level_loaded.connect(closeAndReOpen)
	g.attractMode.connect(closeOnlyIfOpen)


func closeAndReOpen():
	if is_open == true:
		close()
		await get_tree().create_timer(.8).timeout
		open()
	
	else:
		await get_tree().create_timer(.8).timeout
		open()


func open():
	is_open = true
	$anim.play("open")
	g.emit_signal("revealProps")


func close():
	is_open = false
	$anim.play("close")
	g.emit_signal("shrinkProps")
	
func closeOnlyIfOpen():
	if is_open == true:
		$anim.play("close")
		is_open = false
