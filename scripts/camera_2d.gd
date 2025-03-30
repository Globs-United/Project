extends Camera2D

func _process(delta: float) -> void:
	#$".".position.y = get_node("../Player").position.y
	$".".position.x = get_node("../Player").position.x
