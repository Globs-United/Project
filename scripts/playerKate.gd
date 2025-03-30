extends CharacterBody2D

const SPEED = 300.0
const FRICTION = 30.0
const JUMP_VELOCITY = -370.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_on_floor_custom = false;
var jump_check = false
var prepareJump = false;
var jumpTime = 0;
var jumpFrame = 0;
# number of milliseconds player has to click jump after falling off of a platform
# Helps counter lack of hitbox in tail and is generally more user friendly
var jumpTimeMax = 250;

	#prevents flying due to SPACE spam
var playerstate = "idle"
	#idle, walk, jump, death
var death_lock = false
var death_animation_over = false;
var health = 1
var can_be_hit = true
@export var Yworld = false


# I added playerKateOld.gd in case you want to look at some of your old code to recover it



#Each object/character has a Yworld variable (aside from walls)
#use this to denotate if it will first appear in the upside-down world
#don't worry about the setting Yworld before change_world is called
#this is b/c change_world changes Yworld
func _process(delta: float) -> void:
	if Yworld != $AnimatedSprite2D.flip_v:
		Yworld = !Yworld
		change_world()
	if health <= 0:
		death()
	# Don't do any calculations / move player if already dead.
	if death_lock:
		playeranim(delta)
		return;
	
	# Add the gravity.  (+update is_in_air)
	if not is_on_floor_custom:
		velocity += get_gravity() * delta
		#falling?
		if velocity.y < 0:
			playerstate = "jump"
	if is_on_floor_custom:
		jumpTime = jumpTimeMax;
	else:
		jumpTime -= delta * 1e3;
	# Handle jump.
	# Add jump preparation time before jump to account for that one animation frame
	# where the blob tries to jump
	# The blob accelerates upwards slowly during this wait time before immediately going up
	# Can be easily commented out and restored to old version
	if Input.is_action_just_pressed("jump") and jumpTime > 0:
		# Comment out below line to undo jump preparation!
		jumpTime = 0;
		"""
		velocity.y = JUMP_VELOCITY
		playerstate = "jump"
		"""
		prepareJump = true;
		$AnimatedSprite2D.frame = 0;
	else:
		if prepareJump:
			if $AnimatedSprite2D.frame >= 1:
				velocity.y = JUMP_VELOCITY
				prepareJump = false;
			else:
				velocity.y += JUMP_VELOCITY * 0.12
	#"""# End jump preparation toggle
	
		
	# dynamic jump, only letting occur once due to spamming == flying
	# Temporarily removed because it wasn't working
	"""
	if Input.is_action_just_released("jump") and velocity.y < 0:
		if not jump_check:
			velocity.y = JUMP_VELOCITY / 2
		jump_check = true
	"""
		
	#I moved the horizontal flip so it applies on all nodes, not just walking
	$AnimatedSprite2D.flip_h = velocity.x < 0
		
	#Idle / Walk animations
	if playerstate != "jump":# || $AnimatedSprite2D.frame <= 2:
		if prepareJump:
			playerstate = "jump"
		elif abs(velocity.x) < 0.1 and velocity.y == 0:
			playerstate = "idle"
		elif is_on_floor_custom:
			playerstate = "walk"
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		# Add sign of self to prevent getting to 0
		# prevents animation sprite direction from switching after stopping
		velocity.x = move_toward(velocity.x, 0, FRICTION) + 0.01 * sign(velocity.x)
	
	playeranim(delta);
	# replace move and slide so I can handle the collisions manually and add bouncing
	position += velocity * delta;
	
	
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
				$AnimatedSprite2D.frame = min(int(5 - 2.95 * velocity.y / JUMP_VELOCITY), 7);
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
		if !death_animation_over:
			$AnimatedSprite2D.play("death" + animation_name_modifier)
			if $AnimatedSprite2D.frame >= 8:
				death_animation_over = true;
		else:
			$AnimatedSprite2D.play("blank")





func change_world():
	Yworld = !Yworld
	$AnimatedSprite2D.flip_v = !($AnimatedSprite2D.flip_v)
	$".".y *= -1





func death():
	death_lock = true
	playerstate = "death"
	death_animation_over = false;





func _on_being_hit():
	if can_be_hit:
		health -= 1
		can_be_hit = false
		$iFrames.start()



func _on_i_frames_timeout() -> void:
	can_be_hit = true


func _on_leave_screen() -> void:
	health = 0
