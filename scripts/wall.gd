extends StaticBody2D
var initialPosition;

@export var moveDownY = 0;
@export var moveUpY = 0;

var time = 0;
var hasMoved = 0;

func _ready():
	initialPosition = position;

func _process(delta: float) -> void:
	if moveDownY || moveUpY:
		var temp = position.y;
		position.y = initialPosition.y + sin(time * 0.7) * (moveDownY + moveUpY) * 0.5 + (moveDownY - moveUpY) * 0.5;
		hasMoved = position.y - temp;
		time += delta;
