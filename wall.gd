extends StaticBody2D

var screen_size;

func _ready():
	screen_size = get_viewport_rect().size
	
	position *= screen_size.y / 700;
	scale    *= screen_size.y / 700;
