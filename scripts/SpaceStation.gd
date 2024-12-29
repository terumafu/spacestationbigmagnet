extends Node2D

@export var magnet : Node2D;
@export var planet : Node2D;
@export var hpBar : TextureProgressBar;
@export var weightLabel : Label;
@export var pointsLabel : Label;

const MAGNETDISTANCE = 130;

var hp = 100;
var points = 0;
var weight = 0;
var weightMax = 20;

func _process(_delta):
	rotate_magnet_around_mouse();
	rotate_around(planet);
	resize_beam();
	if Input.is_action_pressed("Atoggle"):
		magnet.activate();
	else:
		magnet.deactivate();
	if Input.is_action_just_pressed("switchMagnet"):
		magnet.toggle_magnet_type();
	
func rotate_magnet_around_mouse():
	var temp = get_global_mouse_position() - global_position;
	temp = temp.normalized();
	magnet.global_position = temp * MAGNETDISTANCE + global_position;
	magnet.rotation = -atan2(temp[0],temp[1]) + PI;
	
func resize_beam():
	var change = Input.get_axis("increaseBeamLength","decreaseBeamLength");
	if change != 0:
		magnet.resize_beam(change);

func rotate_around(node):
	var change = Input.get_axis("leftAxisB","rightAxisB");
	if change != 0: 
		var vector = global_position - node.global_position;
		var newvector = vector.rotated(change / 100.0);
		if change < 0 && global_position[1] >= 1000:
			return;
		if change > 0 && global_position[1] <= 100:
			return;
		global_position = newvector + node.global_position;

func _on_collection_area_body_entered(body):
	var danger = true;
	if body.return_size() <= 2 && (body.hasBeenDragged == true || max(body.get_linear_velocity()[0],body.get_linear_velocity()[1]) < 100):
		#collected
		if weight + body.return_size() <= weightMax:
			points += body.return_type();
			weight += body.return_size();
			danger = false;
			pointsLabel.text = str("money: ", points);
			weightLabel.text = str("weight: ", weight, "/", weightMax);
	if danger:
		change_hp(body.return_size() * 5);
	body.queue_free();

func change_hp(num):
	hp -= num;
	hpBar.value = hp;
