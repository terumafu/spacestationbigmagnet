extends Node
var debris = preload("res://scenes/space_debris.tscn");

@export var debrisHolder : Node2D;
@export var spawnTimer : Timer;

func _process(_delta):
	for n in debrisHolder.get_children():
		if n.global_position[0] > 1300:
			n.call_deferred("queue_free");
func spawns_debris(location, type, size, speed):
	var tempDebris = debris.instantiate();
	tempDebris.global_position = location;
	tempDebris.set_sprite(type);
	tempDebris.set_size(size);
	tempDebris.set_speed(speed);
	tempDebris.set_rotation_speed(randf_range(-0.05, 0.05));
	debrisHolder.add_child(tempDebris);
	tempDebris.disable_hitbox();
	var button = Button.new();
	button.text = "start";
	
	button.pressed.connect(start_game);
	tempDebris.get_node("Sprite2D").add_child(button);
	button.position = -Vector2(25,10)
func _on_spawn_timer_timeout():
	spawns_debris(get_random_border_location(),randi_range(0,1),randi_range(1,2),Vector2(randi_range(100,400),randi_range(-10,10)))
	
func get_random_border_location():
	return Vector2(-200,randi_range(48,600));
	
func start_game():
	pass
