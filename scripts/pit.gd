extends Area2D



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player detected")
		get_tree().call_group("player", "change_world")
	if body.is_in_group("enemy"):
		get_tree().call_group("enemy", "change_world")
	print("Body detected! Changing their world")
