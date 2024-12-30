extends AudioStreamPlayer2D
func _process(_delta):
	if get_tree().paused == true:
		volume_db = -10;
	else:
		volume_db = 0;
