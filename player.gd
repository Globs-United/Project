extends CharacterBody2D

@export var accelerationSpeed = 16;
@export var maxSpeed = 400;

var screen_size;
var downNow = 1;

func _ready():
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO;
	
	accelerationSpeed *= screen_size.y / 700;
	maxSpeed *= screen_size.y / 700;

func _process(delta):
	velocity *= 0.9;
	if Input.is_action_pressed("moveRight"):
		velocity.x += accelerationSpeed
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= accelerationSpeed
	if Input.is_action_pressed("moveDown"):
		velocity.y += accelerationSpeed
	if Input.is_action_pressed("moveUp"):
		velocity.y -= accelerationSpeed

	if velocity.length() > maxSpeed:
		velocity = velocity.normalized() * maxSpeed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var velocityTemp = velocity.bounce(collision_info.get_normal())
		if(!(velocity.y * downNow > 0 && velocityTemp.y * downNow < 0)):
			velocity = velocityTemp;
