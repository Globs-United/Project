extends Camera2D

var screen_size;

func _ready():
	screen_size = get_viewport_rect().size;
	var newX = max(get_node("../Player").position.x, screen_size.x / 4);
	var newY = position.y; #get_node("../Player").position.y;
	
	position.x = newX;
	position.y = newY;

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size;
	var newX = max(get_node("../Player").position.x, screen_size.x / 4);
	var newY = position.y; #get_node("../Player").position.y;
	
	position.x = position.x + 0.1 * (newX - position.x);
	position.y = position.y + 0.1 * (newY - position.y);
