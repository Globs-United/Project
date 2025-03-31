extends StaticBody2D


var lightning_striking = false
var player_within = false
@export var Yworld = false
@export var strike_time = 1.0
@export var rest_time = 3.0


func _ready() -> void:
	if Yworld:
		change_world(false);
	$RestTimer.wait_time = rest_time
	$StrikeTimer.wait_time = strike_time
	$RestTimer.start()
	

func _process(_delta: float) -> void:
	if lightning_striking && player_within:
		get_tree().call_group("player", "_on_being_hit")
	#if Yworld != $AnimatedSprite2D.flip_v:
		#Yworld = !Yworld
		#change_world()
	if Yworld:
		$AnimatedSprite2D.play("blinkY")
	else:
		$AnimatedSprite2D.play("blink")





func _on_strike_timer_timeout() -> void:
	$RestTimer.start()
	$Lightning/AnimatedSprite2D.play("wait")
	lightning_striking = false


func _on_rest_timer_timeout() -> void:
	lightning_striking = true
	$StrikeTimer.start()
	if Yworld:
		$Lightning/AnimatedSprite2D.play("strikeY")
	else:
		$Lightning/AnimatedSprite2D.play("strike")


func _on_lightning_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = true


func _on_lightning_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = false

func change_world(flipY = true):
	if flipY:
		Yworld = !Yworld;
	#$AnimatedSprite2D.flip_v = !($AnimatedSprite2D.flip_v);
	$Lightning/AnimatedSprite2D.flip_v = $AnimatedSprite2D.flip_v;
	position.y = 600 - (position.y - scale.y * 570);
	scale.y *= -1;
