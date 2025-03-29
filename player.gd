extends Area2D

@export var speed = 400;
var velocity = Vector2.ZERO;

var screen_size;

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	velocity *= 0;
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("moveDown"):
		velocity.y += 1
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
"""
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print(1);
		#velocity = velocity.bounce(collision_info.get_normal())
"""
