extends Control

@export var tutorial = true
@export var hide = false;
var prev_zoom
var change = true

func _ready() -> void:
	$Music.value = get_node("../SoundPlayer").music_volume
	$Noise.value = get_node("../SoundPlayer").noise_volume
	$RichTextLabel.hide()
	prev_zoom = get_node("../Camera2D").zoom.x


func _process(_delta: float) -> void:
	if prev_zoom != get_node("../Camera2D").zoom.x  && change:
		scale *= 1.9
		change = false
	position = get_node("../Camera2D").position
	if tutorial:
		$RichTextLabel.show()
	if Input.is_action_just_pressed("menu") || hide:
		$Music.visible = !$Music.visible
		$Music.editable = !$Music.editable
		$Noise.visible = !$Noise.visible
		$Noise.editable = !$Noise.editable
		tutorial = false
		$RichTextLabel.hide()
		hide = false;


func _on_music_value_changed(value: float) -> void:
	get_node("../SoundPlayer").music_volume = $Music.value


func _on_noise_value_changed(value: float) -> void:
	get_node("../SoundPlayer").noise_volume = $Noise.value
