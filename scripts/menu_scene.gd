extends Node2D
@export var earth : Sprite2D;
@export var titletext : Label;
const earthPosition = Vector2(1152/2, 648/2);
var timePassed = 0;
signal startGame;
func _process(delta):
	earth.global_position[1] = earthPosition[1] + 10 * sin(timePassed * 2);
	timePassed += delta;


func _on_spawner_start_game_signal():
	startGame.emit(self);
