extends Area2D



func _process(delta: float) -> void:
	$AnimatedSprite2D.play("finale")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("player", "finish_line")
