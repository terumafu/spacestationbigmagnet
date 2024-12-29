extends Node2D

@export var MagArea : Area2D;
@export var beamSprite : Sprite2D;
@export var magSprite = Sprite2D;

var debrisArr = [];
var magnetType = 0;

const MAXMAGNETPOWER = 15.0;

var currentMagnetPower = 0.0;
var sizeMultiplier = 1.0;
var magnetArr = [
	{"magnetSprite": "res://assets/redmagnet.png", "beamSprite": "res://assets/redBeam.png", "direction": -1},
	{"magnetSprite": "res://assets/bluemagnet.png", "beamSprite": "res://assets/blueBeam.png", "direction": 1}
];

func _process(_delta):
	for element in debrisArr:
		element.apply_impulse(magnetArr[magnetType].direction * get_vector() * currentMagnetPower * sizeMultiplier);

func get_vector():
	return (MagArea.global_position - global_position).normalized();

func _on_pos_mag_area_body_entered(body):
	body.dragged();
	debrisArr.append(body);

func _on_pos_mag_area_body_exited(body):
	debrisArr.remove_at(debrisArr.find(body));

func activate():
	MagArea.modulate.a = currentMagnetPower/MAXMAGNETPOWER;
	MagArea.monitoring = true;
	currentMagnetPower = lerp(currentMagnetPower, MAXMAGNETPOWER, 0.02)
func deactivate():
	MagArea.monitoring = false;
	MagArea.modulate.a = currentMagnetPower/MAXMAGNETPOWER;
	currentMagnetPower = lerp(currentMagnetPower, 0.0, 0.1)
	
func toggle_magnet_type():
	if magnetType == 0:
		magnetType = 1;
	else:
		magnetType = 0;
	update_magnet();

func update_magnet():
	magSprite.texture = load(magnetArr[magnetType].magnetSprite);
	beamSprite.texture = load(magnetArr[magnetType].beamSprite);
	
func resize_beam(change):
	if change < 0 && MagArea.scale[1] > 3 || change > 0 && MagArea.scale[1] < 0.5:
		return;
	sizeMultiplier = 1.0 / (MagArea.scale[1] / 3.0);
	MagArea.scale += Vector2(change/30.0,-change/8.0);
	MagArea.position.y = -15 -( MagArea.scale[1] * 100)/2;
