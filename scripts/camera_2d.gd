extends Camera2D

func _process(delta: float) -> void:
	$".".position.y = get_node("../Player").position.y
	
