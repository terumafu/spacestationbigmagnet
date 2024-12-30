extends Node
var game = preload("res://scenes/main_scene.tscn");
@export var audioplayer : AudioStreamPlayer2D;
func _on_menu_scene_start_game(node):
	node.queue_free();
	var temp = game.instantiate();
	call_deferred("add_child",temp);
	
	


func _on_menu_scene_change_volume(volume):
	Global.volume = volume;
