extends CharacterBody2D

const SPEED = 250.0;
const FRICTION = 30.0;
const JUMP_VELOCITY = -345.0;
const TERMINAL_VELOCITY = 500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

var initialPosition;
var initialWorld;
@export var initialHealth = 1;

var is_on_floor_custom = false;
var jump_check = false
var prepareJump = false;
var jumpTime = 0;
var jumpFrame = 0;
# number of milliseconds player has to click jump after falling off of a platform
# Helps counter lack of hitbox in tail and is generally more user friendly
var jumpTimeMax = 250;
var playerstate = "idle"
	#idle, walk, jump, death
var death_lock = false
var death_animation_over = true;
var health = initialHealth;
var can_be_hit = true
@export var Yworld = false
var hasTraveled = false;


# I added playerKateOld.gd in case you want to look at some of your old code to recover it



#Each object/character has a Yworld variable (aside from walls)
#use this to denotate if it will first appear in the upside-down world
#don't worry about the setting Yworld before change_world is called
#this is b/c change_world changes Yworld

func _ready() -> void:
	initialPosition = position;
	initialWorld = Yworld;

func _process(delta: float) -> void:
	if Yworld != $AnimatedSprite2D.flip_v:
		Yworld = !Yworld
		change_world()
	if health <= 0 && !death_lock:
		death()
		print("player died")
	# Don't do any calculations / move player if already dead.
	if death_lock:
		playeranim(delta)
		return;

	
	# Add the gravity.  (+update is_in_air)
	if not is_on_floor_custom:
		velocity.y += gravity * delta
		#double checks if jumping
		if -1*sign(gravity) == sign(velocity.y):
			playerstate = "jump"
		
	#I moved the horizontal flip so it applies on all nodes, not just walking
	#??? their relative x positions==0 means that only the visible sprite needs to flip
	$AnimatedSprite2D.flip_h = velocity.x < 0
		
	#Idle / Walk animations
	if playerstate != "jump":# || $AnimatedSprite2D.frame <= 2:
		if prepareJump:
			playerstate = "jump"
		elif abs(velocity.x) < 0.2 and abs(velocity.y) < 0.2:
			playerstate = "idle"
		elif is_on_floor_custom:
			playerstate = "walk"

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	velocity.x *= 0.8
	if direction:
		velocity.x += 0.35 * direction * SPEED
		
	if abs(velocity.y) > TERMINAL_VELOCITY:
		velocity.y = TERMINAL_VELOCITY*sign(velocity.y)
	playeranim(delta);
	
	# Handle collisions
	var collision_info = move_and_collide(velocity * delta);
	is_on_floor_custom = false;
	if collision_info:
		var velocityTemp = velocity.bounce(collision_info.get_normal());
		var downDir = -1 if Yworld else 1;
		if(!(velocity.y * downDir > 0 && velocityTemp.y * downDir < 0)):
			velocity = velocityTemp;
		else:
			velocity.y = 0;
			is_on_floor_custom = true;
			
	# replace move and slide so I can handle the collisions manually and add bouncing
	
	if is_on_floor_custom:
		jumpTime = jumpTimeMax;
	else:
		jumpTime -= delta * 1e3;
	
	if Input.is_action_just_pressed("jump") and jumpTime > 0:
		# Comment out below line to undo jump preparation!
		jumpTime = 0;
		velocity.y = jump_velocity()
		prepareJump = false;
		playerstate = "jump"
	
	position += velocity * delta;
	
	
	if position.x < scale.x * 110:
		position.x = scale.x * 110;
	elif (position.y > 750 && !Yworld) || (position.y < -50 && Yworld):
		death();



# I made the death animation not loop, and compressed the if yworld or not
# by adding a "Y" to the end if in yWorld
func playeranim(delta):
	var animation_name_modifier = "Y" if Yworld else "";
	if playerstate == "idle":
		$AnimatedSprite2D.play("idle" + animation_name_modifier)
	elif playerstate == "walk":
		$AnimatedSprite2D.play("walk" + animation_name_modifier)
	elif playerstate == "jump":
		$AnimatedSprite2D.play("jump" + animation_name_modifier)
		#Make the animation frame be based off of y velocity instead of time.
		if !prepareJump:
			if jumpTime <= jumpTimeMax * 0.9:
				var jump_modifier = 2.95 if Yworld else -2.95;
				$AnimatedSprite2D.frame = min(int(5 + jump_modifier * velocity.y / JUMP_VELOCITY), 7);
				jumpFrame = 0;
			else:
				jumpFrame = max(jumpFrame, 8);
				if jumpFrame < 12:
					$AnimatedSprite2D.frame = int(jumpFrame);
					jumpFrame += delta * 10;
				else:
					jumpFrame = 0;
					playerstate = "idle";
		else:
			jumpFrame = 0;
	elif playerstate == "death":
		$AnimatedSprite2D.play("death" + animation_name_modifier)





func change_world():
	print("Player changing world")
	Yworld = !Yworld
	$AnimatedSprite2D.flip_v = !($AnimatedSprite2D.flip_v)
	#replaced flipping y of self in case it changed the player's position in the game
	$AnimatedSprite2D.position.y *= -1
	$CollisionShape2D.position.y *= -1
	$VisibleOnScreenNotifier2D.position.y *= -1
	gravity *= -1;
	#jump velocity "flipped" in jump_velocity()
	hasTraveled = true;

func exitting_pit(tVelY):
	velocity.y = tVelY
	print(velocity.y)





func death():
	death_lock = true
	playerstate = "death"
	death_animation_over = false;
	print("player died: death_lock = "+str(death_lock)+"death_animation_over = "+str(death_animation_over))
	



func jump_velocity() -> float:
	if Yworld:
		return JUMP_VELOCITY *-1
	else:
		return JUMP_VELOCITY





func _on_being_hit():
	if can_be_hit:
		health -= 1
		can_be_hit = false
		$iFrames.start()

func _on_check_point(newPos, newY):
	initialPosition = newPos;
	initialWorld = newY;



func _on_i_frames_timeout() -> void:
	can_be_hit = true

#REMEMBER TO TURN BACK ON WITH CAM-Y
func _on_leave_screen() -> void:
	#health = 0
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if death_lock:
		$postDeath.start()
		playerstate = "gone"
	
		


func _on_post_death_timeout() -> void:
	print("player died: death_lock = "+str(death_lock)+"death_animation_over = "+str(death_animation_over))
	position = initialPosition;
	death_lock = false;
	playerstate = "idle";
	death_animation_over = false;
	velocity = Vector2(0, 0);
	health = initialHealth;
	if Yworld != initialWorld:
		change_world();
		hasTraveled = false;
