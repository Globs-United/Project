extends Camera2D

var screen_size;
@export var smallScreen = false;

func _ready():
	screen_size = get_viewport_rect().size;
	var newX = max(get_node("../Player").position.x, screen_size.x / 4);
	var newY = 175 if smallScreen else position.y; #get_node("../Player").position.y;
	
	position.x = newX;
	position.y = newY;
	
	zoom.x = 2 if smallScreen else 1;
	zoom.y = 2 if smallScreen else 1;

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size;
	var newX = max(get_node("../Player").position.x, screen_size.x / 4);
	var newY = position.y; #get_node("../Player").position.y;
	var newS = 2 if smallScreen else 1;
	
	if get_node("../Player").hasTraveled:
		newY = 350;
		newS = 1;
	
	position.x = position.x + 0.1 * (newX - position.x);
	position.y = position.y + 0.1 * (newY - position.y);
	
	zoom.x = zoom.x + 0.03 * (newS - zoom.x);
	zoom.y = zoom.y + 0.03 * (newS - zoom.y);
