extends RigidBody2D;

@export var sprite : Sprite2D;
@export var collisionShape : CollisionShape2D;
var hasBeenDragged = false;
func dragged():
	hasBeenDragged = true;
signal breakSignal;
var type;
var spriteArr = ["res://assets/spacerock.png","res://assets/gold.png"]
var scrapArr = [
	["res://assets/graychunk1.png","res://assets/graychunk2.png","res://assets/graychunk3.png"],
	["res://assets/yellowchunk1.png","res://assets/yellowchunk2.png","res://assets/yellowchunk3.png"]
];
var health;
func _process(_delta):
	if get_colliding_bodies() != []:
		for n in get_colliding_bodies():
			if n.linear_velocity.length() > 60:
				health -= n.return_size();
		if health < 0:
			break_apart();
			
func break_apart():
	collisionShape.disabled = true;
	breakSignal.emit(global_position,return_size(),type);
	queue_free();
	
func set_sprite(num):
	sprite.texture = load(spriteArr[num]);
	type = num;

func set_speed(vec):
	apply_impulse(vec);
func set_size(num):
	sprite.scale = Vector2(1,1) * num;
	collisionShape.scale = Vector2(1,1) * num;
	mass = num * 2;
	health = num;
func return_size():
	return sprite.scale[0];
func return_type():
	return type;
