@tool
extends Entity

# Wall

func _ready():
	if not Engine.is_editor_hint():
		randomize()
		$Wall_Rocks2.rotation_degrees.y = snapped(randi_range(0,360),90)
