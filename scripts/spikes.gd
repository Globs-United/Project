extends StaticBody2D

@export var Yworld = false
var player_within = false

func _process(_delta: float) -> void:
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
