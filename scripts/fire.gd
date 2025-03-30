extends Area2D

@export var Yworld = false
var player_within = false

func _ready() -> void:
	if Yworld != $AnimatedSprite2D.flip_v:
		Yworld = !Yworld
		change_world()
	if Yworld:
		$AnimatedSprite2D.play("fireY")
	else:
		$AnimatedSprite2D.play("fire")

func _process(delta: float) -> void:
	if player_within:
		get_tree().call_group("player", "_on_being_hit")


func change_world():
	Yworld = !Yworld
	$AnimatedSprite2D.flip_v = !($AnimatedSprite2D.flip_v)
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = false
