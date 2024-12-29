extends Node2D
@export var earth : Sprite2D;
const earthPosition = Vector2(1152/2, 648/2);
var timePassed = 0;
func _process(delta):
	earth.global_position[1] = earthPosition[1] + 10 * sin(timePassed * 2);
	timePassed += delta;
	
