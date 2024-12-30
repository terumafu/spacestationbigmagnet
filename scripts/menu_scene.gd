extends Node2D
@export var earth : Sprite2D;
@export var titletext : Label;
const earthPosition = Vector2(1152/2, 648/2);
var timePassed = 0;
signal startGame;
signal changeVolume;
func _process(delta):
	earth.global_position[1] = earthPosition[1] + 10 * sin(timePassed * 2);
	timePassed += delta;


func _on_spawner_start_game_signal():
	startGame.emit(self);


func _on_h_slider_value_changed(value):
	if value == 0:
		changeVolume.emit(-80);
		return;
	changeVolume.emit((value - 75) /4);
