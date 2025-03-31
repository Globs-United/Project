extends Camera2D

var screen_size;

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size
	#$".".position.y = get_node("../Player").position.y
	$".".position.x = max(get_node("../Player").position.x, screen_size.x / 4);
