@tool
extends Entity


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("spawn_line"):
			if is_instance_valid(anchorCell):
				emit_signal("spawnLine", anchorCell.gridPos)
