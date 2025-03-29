extends Sprite2D

var screen_size;

func _ready():
	screen_size = get_viewport_rect().size
	
	position = Vector2(screen_size.x / 2, screen_size.y * 3 / 4);
	scale    = Vector2(screen_size.x / 100, screen_size.y / 200);
