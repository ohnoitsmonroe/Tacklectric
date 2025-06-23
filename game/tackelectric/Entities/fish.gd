@tool
extends Entity

# Fish

func _ready():
	if not Engine.is_editor_hint():
		g.winText.connect(bite)
	
	g.revealProps.connect(reveal)
	g.shrinkProps.connect(hideProp)

func bite():
	$anim.play("bite")

func hideProp():
	$anim.play("shrink")

func reveal():
	$anim.play("reveal")
