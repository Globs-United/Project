extends StaticBody2D


var lightning_striking = false
var player_within = false


func _ready() -> void:
	$RestTimer.start()

func _process(_delta: float) -> void:
	if lightning_striking && player_within:
		get_tree().call_group("player", "_on_being_hit")



func _on_strike_timer_timeout() -> void:
	lightning_striking = false
	$RestTimer.start()


func _on_rest_timer_timeout() -> void:
	$StrikeTimer.start()


func _on_lightning_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = true


func _on_lightning_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_within = false
