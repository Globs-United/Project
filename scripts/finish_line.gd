extends Area2D



func _process(delta: float) -> void:
	$AnimatedSprite2D.play("finale")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		if current_scene_file == "res://winner_screen.tscn":
				get_tree().quit()
		var next_level_num = current_scene_file.to_int()+1
		if get_tree().change_scene_to_file("res://lvl"+str(next_level_num)+".tscn") == ERR_CANT_ACQUIRE_RESOURCE:
			get_tree().change_scene_to_file("res://winner_screen.tscn")
