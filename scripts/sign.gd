extends Area2D

@export var text = ""

var player_within = false
var state = 1


func _ready():
	$Panel/RichTextLabel.text = text
	$Panel/RichTextLabel.push_font_size(50)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && player_within:
		state += 1
		if state > 1:
			state = 0
	state_display()
		



func state_display():
	if state == 0:
		$Panel.hide()
	if state == 1:
		$Panel.show()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = true



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = false
