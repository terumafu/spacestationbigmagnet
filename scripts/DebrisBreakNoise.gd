extends AudioStreamPlayer2D

func _ready(): #https://www.youtube.com/watch?v=npL3NfpOd9A
	pitch_scale += randf_range(-0.2, 0.2)
func _on_finished():
	queue_free();
