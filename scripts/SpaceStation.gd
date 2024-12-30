extends Node2D

@export var magnet : Node2D;
@export var planet : Node2D;
@export var hpBar : TextureProgressBar;
@export var weightLabel : Label;
@export var pointsLabel : Label;

const MAGNETDISTANCE = 130;

var hp = 100;
var money = 0;
var weight = 0;
var weightMax = 20;
var speed = 1;

signal gameOver;
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
		var newvector = vector.rotated(change / 100.0 * speed);
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
			change_money(body.return_type());
			weight += body.return_size();
			danger = false;
			
			weightLabel.text = str("weight: ", weight, "/", weightMax);
	if danger:
		change_hp(-body.return_size() * 5);
	body.queue_free();

func change_hp(num):
	hp += num;
	if hp <= 0:
		gameOver.emit();
	if hp > 100:
		hp = 100;
	hpBar.value = hp;

func change_money(num):
	money += num;
	pointsLabel.text = str("money: ", money);

func change_max_weight(num):
	weightMax += num;
	weightLabel.text = str("weight: ", weight, "/", weightMax);
	
func change_weight(num):
	weight += num;
	weightLabel.text = str("weight: ", weight, "/", weightMax);
