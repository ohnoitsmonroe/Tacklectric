extends Button

@export var audio_bus : String = "SFX"

@onready var _bus := AudioServer.get_bus_index(audio_bus)

var isMuted : bool = AudioServer.is_bus_mute(_bus)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isMuted:
		set_text("Mute %s (Muted)" % audio_bus)
	else:
		set_text("Mute %s (Unmuted)" % audio_bus)

func _on_pressed() -> void:
	AudioServer.set_bus_mute(_bus, !isMuted)
	isMuted = !isMuted
