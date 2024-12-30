extends AudioStreamPlayer2D

func _ready(): #https://www.youtube.com/watch?v=npL3NfpOd9A
	volume_db = Global.volume;
	pitch_scale += randf_range(-0.2, 0.2)
	
func set_sound(sound):
	stream = sound;
func _on_finished():
	call_deferred("queue_free");
