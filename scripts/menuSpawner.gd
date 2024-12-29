extends Node
var debris = preload("res://scenes/space_debris.tscn");

@export var debrisHolder : Node2D;
@export var spawnTimer : Timer;

func spawns_debris(location, type, size, speed):
	var tempDebris = debris.instantiate();
	tempDebris.global_position = location;
	tempDebris.set_sprite(type);
	tempDebris.set_size(size);
	tempDebris.set_speed(speed);
	debrisHolder.add_child(tempDebris);
