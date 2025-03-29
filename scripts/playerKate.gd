extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_check = false
var playerstate = "idle"
	#idle, run, jump


#I said screw it and ripped code from my previous game jam since it didn't autofill to something like this, like I what occurred last time

func _physics_process(delta: float) -> void:
	
	# Add the gravity.  (+update is_in_air)
	if not is_on_floor():
		velocity += get_gravity() * delta
		#falling?
		if velocity.y < 0:
			playerstate = "jump"
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerstate = "jump"
		
	#dynamic jump, only letting occur once due to spamming == flying
	if Input.is_action_just_released("jump") and velocity.y < 0:
		if not jump_check:
			velocity.y = JUMP_VELOCITY / 2
		jump_check = true
		
		
	if is_on_floor() and velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		playerstate = "run"
	elif is_on_floor() and velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		playerstate = "run"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	
	if velocity.x == 0 and velocity.y == 0:
		playerstate = "idle"
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	playeranim()
	move_and_slide()

func playeranim():
	if playerstate == "idle":
		$AnimatedSprite2D.play("test")
	#elif playerstate == "":
	#	$AnimatedSprite2D.play("")
