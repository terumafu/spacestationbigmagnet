extends Node
var debris = preload("res://scenes/space_debris.tscn");
var chunk = preload("res://scenes/debrisChunk.tscn");
@export var debrisHolder : Node2D;

func spawns_debris():
	var tempDebris = debris.instantiate();
	tempDebris.global_position = get_random_border_location();
	tempDebris.set_sprite(randi_range(0,1));
	tempDebris.set_size(randi_range(1,5));
	tempDebris.set_speed(Vector2(randi_range(50,400),randi_range(-10,10)));
	debrisHolder.add_child(tempDebris);
	tempDebris.breakSignal.connect(debrisBreaks);

func debrisBreaks(location, size, type):
	spawn_chunks(location,size,type);
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
	spawns_debris();
func get_random_border_location():
	return Vector2(-400,randi_range(0,648));
