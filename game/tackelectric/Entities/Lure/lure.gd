@tool
extends Entity


# Lure

func _ready():
	if not Engine.is_editor_hint():
		await get_tree().create_timer(randf_range(.1,.6)).timeout
		if !get_parent().get_parent() is Compartment:
			$sway_anim.play("sway")
