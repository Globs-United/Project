extends CharacterBody2D

@export var accelerationSpeed = 16;
@export var maxSpeed = 400;
@export var jumpTimeLimit = 150;
@export var accelerationFromGravity = 10;
@export var jumpStrength = 230;

var screen_size;
var downNow = 1;

var timeToJump = 0;

func _ready():
	screen_size = get_viewport_rect().size;
	velocity = Vector2.ZERO;
	
	accelerationSpeed *= screen_size.y / 700;
	maxSpeed *= screen_size.y / 700;

func _process(delta):
	velocity.x *= 0.9;
	if Input.is_action_pressed("moveRight"):
		velocity.x += accelerationSpeed;
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= accelerationSpeed;
	if Input.is_action_pressed("moveUp") && timeToJump > 0:
		velocity.y = -jumpStrength * downNow;
		timeToJump = 0
	
	# Go to other world
	if((position.y - 0.5 * screen_size.y) * downNow > 0):
		downNow *= -1;
		if(abs(velocity.y) < jumpStrength):
			velocity.y = -jumpStrength * downNow;
	
	velocity.y += accelerationFromGravity * downNow;
	
	if velocity.length() > maxSpeed:
		velocity = velocity.normalized() * maxSpeed;
	
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size);
	
	timeToJump -= 1000 * delta;

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta);
	if collision_info:
		var velocityTemp = velocity.bounce(collision_info.get_normal());
		if(!(velocity.y * downNow > 0 && velocityTemp.y * downNow < 0)):
			velocity = velocityTemp;
		else:
			timeToJump = jumpTimeLimit;
			velocity.y = 0;
