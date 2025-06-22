extends AudioStreamPlayer3D

@export var streams : Array[AudioStream]

@export var pitch_min := 1.0
@export var pitch_max := 1.0

func play_sfx():
	if streams.size() > 0:
		stream = streams[randi_range(0, streams.size() - 1)]
	
	pitch_scale = randf_range(pitch_min, pitch_max)
	
	play()
