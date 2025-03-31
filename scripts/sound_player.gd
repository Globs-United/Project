extends AudioStreamPlayer

#this is a global player

@export var music_volume = -10.0
@export var noise_volume = -10.0
var music_position = 0.0
var prev_Yworld = false

func _ready() -> void:
	$Traffic.play()
	$Dark.stop()
	play()

func _process(_delta: float) -> void:
	volume_db = music_volume
	$Dark.volume_db = music_volume
	$Traffic.volume_db = noise_volume
	music_position = get_playback_position()
	if get_node("../Player").Yworld != prev_Yworld:
		prev_Yworld = get_node("../Player").Yworld
		if prev_Yworld:
			$Dark.play(music_position)
			stop()
		else:
			$Dark.stop()
			play(music_position)
		
