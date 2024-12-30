extends Node
var game = preload("res://scenes/main_scene.tscn");

func _on_menu_scene_start_game(node):
	node.queue_free();
	var temp = game.instantiate();
	call_deferred("add_child",temp);
	
	
