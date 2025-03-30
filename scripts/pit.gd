extends Area2D

var initVel
var player_within_counter = 0
var player_within = false

func _process(delta: float) -> void:
	if player_within:
		player_within_counter += 1
		print(player_within_counter)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		initVel = get_node("../Player").velocity.y
		player_within = true
	print(initVel)
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player detected")
		get_tree().call_group("player", "change_world")
		get_tree().call_group("player", "exitting_pit", initVel)
	if body.is_in_group("enemy"):
		get_tree().call_group("enemy", "change_world")
	print("Body detected! Changing their world")
	player_within = false
