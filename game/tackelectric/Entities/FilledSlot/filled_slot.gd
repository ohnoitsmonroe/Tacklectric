@tool
extends Entity

@export var texture1 : Texture
@export var texture2 : Texture

@export var topTexture1 : Texture
@export var topTexture2 : Texture

func _ready():
	if not Engine.is_editor_hint():
		randomize()
		$Island2.position.y += randf_range(-.05, .05)
		$grassTop.rotation_degrees.y = snapped(randi_range(0,360),90)
		
		var chance = randi_range(0,10)
		
		if chance > 8:
			$grassTuft.texture = texture1
			$grassTop.texture = topTexture2
		elif chance > 5:
			$grassTuft.texture = texture2
			$grassTop.texture = topTexture2
		else:
			$grassTuft.visible = false
			$grassTop.texture = topTexture1
