extends StaticBody2D

@export var Yworld = false
var player_within = false

var initialPosition;

@export var moveDownY = 0;
@export var moveUpY = 0;

var time = 0;

func _ready():
	initialPosition = position;

func _process(delta: float) -> void:
	if moveDownY || moveUpY:
		position.y = initialPosition.y + sin(time * 1.5) * (moveDownY + moveUpY) * 0.5 + (moveDownY - moveUpY) * 0.5;
		time += delta;

	if player_within:
		get_tree().call_group("player", "_on_being_hit")
	#if Yworld != $Sprite2D.flip_v:
		#Yworld = !Yworld
		#change_world()
	if Yworld:
		$Sprite2D.play("spikeY")
	else:
		$Sprite2D.play("spike")
	

#func change_world():
	#Yworld = !Yworld
	#$Sprite2D.flip_v = !($Sprite2D.flip_v)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = false
