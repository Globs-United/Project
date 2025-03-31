extends Area2D

@export var Yworld = false



func _process(_delta: float) -> void:
	if Yworld != $AnimatedSprite2D.flip_v:
		Yworld = !Yworld
		change_world()
	if Yworld:
		$AnimatedSprite2D.play("flagY")
	else:
		$AnimatedSprite2D.play("flag")


func change_world():
	Yworld = !Yworld
	$AnimatedSprite2D.flip_v = !($AnimatedSprite2D.flip_v)


func _on_body_entered(body: Node2D) -> void:
	pass
