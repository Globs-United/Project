extends AudioStreamPlayer

#this is a global player

@export var music_volume = -10.0
@export var noise_volume = -10.0
var music_position = 0.0
var prev_Yworld = false

var transition = 0.0;
var transitioning = "none";

const QUIET = 15;

func _ready() -> void:
	$Traffic.play()
	if !get_node("../Player").Yworld:
		$Dark.stop()
		play()
	else:
		stop()
		$Dark.play()

func _process(delta: float) -> void:
	volume_db = music_volume
	$Dark.volume_db = music_volume
	$Traffic.volume_db = noise_volume
	music_position = 0
	if get_node("../Player").Yworld != prev_Yworld:
		prev_Yworld = get_node("../Player").Yworld
		if prev_Yworld:
			music_position = get_playback_position()
			$Dark.play(music_position)
			transitioning = "dark";
			transition = 0.0;
			#stop()
		else:
			music_position = $Dark.get_playback_position()
			#$Dark.stop()
			play(music_position)
			transitioning = "light";
			transition = 0.0;
	
	if(transitioning != "none"):
		transition += delta * 1.5;
		
		if transitioning == "light":
			volume_db = min(transition, 1) * (QUIET + music_volume) - QUIET;
			$Dark.volume_db = (1 - min(transition, 1)) * (QUIET + music_volume) - QUIET;
			if transition >= 1.0:
				transitioning = "none";
				$Dark.stop()
		else:
			volume_db = (1 - min(transition, 1)) * (QUIET + music_volume) - QUIET;
			$Dark.volume_db = min(transition, 1) * (QUIET + music_volume) - QUIET;
			if transition >= 1.0:
				transitioning = "none";
				stop()

func _on_traffic_finished():
	$Traffic.play(0);
	
func _on_dark_finished():
	$Dark.play(0);
	
func _on_finished():
	play(0);
