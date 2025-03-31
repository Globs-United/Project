extends Area2D

var initVel
var player_within_counter = 0
var player_within = false;

var scene = preload("res://object_scenes/wall.tscn");
var instance = false;

@export var oneWay = false;

func _process(delta: float) -> void:
	if player_within:
		player_within_counter += 1
		print(player_within_counter)
	if instance && get_node("../Player").death_lock:
		instance.free();


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		initVel = get_node("../Player").velocity.y
		player_within = true
	print(initVel)
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player detected")
		get_tree().call_group("player", "change_world");
		get_tree().call_group("player", "exitting_pit", initVel)
		if oneWay:
			instance = scene.instantiate()
			get_node("../").add_child(instance);
			
			instance.position = position;
			instance.scale = 5 * scale;
			instance.visible = false;
	if body.is_in_group("enemy"):
		get_tree().call_group("enemy", "change_world")
	print("Body detected! Changing their world")
	player_within = false
