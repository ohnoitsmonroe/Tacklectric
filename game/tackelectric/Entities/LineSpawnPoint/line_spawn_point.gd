extends Entity


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_line"):
		emit_signal("spawnLine", anchorCell.gridPos)
