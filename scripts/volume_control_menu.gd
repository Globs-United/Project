extends Control

@export var tutorial = true
#var cam : PackedScene = preload("res://object_scenes/camera_2d.tscn")

func _ready() -> void:
	$Music.value = get_node("../SoundPlayer").music_volume
	$Noise.value = get_node("../SoundPlayer").noise_volume
	$RichTextLabel.hide()


func _process(_delta: float) -> void:
	position = get_node("../Camera2D").position
	if tutorial:
		$RichTextLabel.show()
	if Input.is_action_just_pressed("menu"):
		$Music.visible = !$Music.visible
		$Music.editable = !$Music.editable
		$Noise.visible = !$Noise.visible
		$Noise.editable = !$Noise.editable
		tutorial = false
		$RichTextLabel.hide()


func _on_music_value_changed(value: float) -> void:
	get_node("../SoundPlayer").music_volume = $Music.value


func _on_noise_value_changed(value: float) -> void:
	get_node("../SoundPlayer").noise_volume = $Noise.value
