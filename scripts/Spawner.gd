extends Node
var debris = preload("res://scenes/space_debris.tscn");
var chunk = preload("res://scenes/debrisChunk.tscn");
var breakNoise = preload("res://scenes/soundplayer.tscn");
@export var debrisHolder : Node2D;
@export var spawnTimer : Timer;
@export var afterWaveTimer : Timer;

var spawnArr = [];

signal transitionBreakSignal;

func spawns_debris(location, type, size, speed):
	var tempDebris = debris.instantiate();
	tempDebris.global_position = location;
	tempDebris.set_sprite(type);
	tempDebris.set_size(size);
	tempDebris.set_speed(speed);
	debrisHolder.add_child(tempDebris);
	tempDebris.breakSignal.connect(debrisBreaks);

func debrisBreaks(location, size, type):
	spawn_chunks(location,size,type);
	var temp = breakNoise.instantiate();
	temp.set_sound(load("res://sounds/ROCKS AND STONES IMPACT - (Sound Effect)-[AudioTrimmer.com].mp3"));
	call_deferred("add_child",temp);
	if size == 1:
		return;
	for n in size:
		var tempDebris = debris.instantiate();
		tempDebris.global_position = location + Vector2(size * 4 * randi_range(-5,5),size * 4 * randi_range(-5,5));;
		tempDebris.set_sprite(type);
		tempDebris.set_size(1);
		tempDebris.set_speed(Vector2(40 * pow(-1,randi_range(0,1)),40 * pow(-1,randi_range(0,1))));
		debrisHolder.add_child(tempDebris);
		tempDebris.breakSignal.connect(debrisBreaks);

func spawn_chunks(location,numchunks : int,type):
	for n in numchunks:
		var temp = chunk.instantiate();
		temp.set_sprite(type, n % 3);
		temp.set_speed(Vector2(5 * randi_range(-10,10),50));
		call_deferred("add_child",temp);
		temp.global_position = location + Vector2(numchunks * 4 * randi_range(-5,5),numchunks * 4 * randi_range(-5,5));

func _on_timer_timeout():
	if spawnArr.size() > 0:
		var temp = spawnArr.pop_front()
		spawns_debris(get_random_border_location(), temp.type, temp.size, temp.speed);
		spawnTimer.start();
	else:
		afterWaveTimer.start();
func get_random_border_location():
	return Vector2(-400,randi_range(0,648));
func set_wave(arr,spawntime):
	spawnArr.append_array(arr);
	spawnTimer.wait_time = spawntime;
	spawnTimer.start();

func _on_after_wave_timer_timeout():
	#go to pause screen first
	transitionBreakSignal.emit();


func _on_killtimer_timeout():
	for n in debrisHolder.get_children():
		if is_out_of_bounds(n):
			n.calldeferred("queue_free");
func is_out_of_bounds(body):
	if body.global_position[0] > 1300 || body.global_position[0] < -500 || body.global_position[1] > 1400 || body.global_position[1] < -400:
		return true;
	return false;
