extends RigidBody2D

@export var sprite : Sprite2D;
@export var timer : Timer;

var chunks = [
	["res://assets/graychunk1.png","res://assets/graychunk2.png","res://assets/graychunk3.png"],
	["res://assets/yellowchunk1.png","res://assets/yellowchunk2.png","res://assets/yellowchunk3.png"]
	];

func set_sprite(rocktype, numchunk):
	sprite.texture = load(chunks[rocktype][numchunk]);

func _process(delta):
	modulate.a = (timer.time_left) / timer.wait_time;
func _on_timer_timeout():
	queue_free();
func set_speed(vector):
	apply_impulse(vector);
