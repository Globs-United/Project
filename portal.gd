extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("player", "change_world", body)
	if body.is_in_group("enemy"):
		get_tree().call_group("enemy", "change_world", body)
	pass # Replace with function body.
