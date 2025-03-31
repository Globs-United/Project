extends Area2D

var player_within = false
var state = 0

func state_display():
	if state == 0:
		0# Display unchecked
	if state == 1:
		0# Display checked
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("player", "_on_check_point", position)
