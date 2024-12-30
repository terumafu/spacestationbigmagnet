extends Node2D
var hp = 100;
@export var hpBar : TextureProgressBar;
var collisionArray = []
signal gameOver;
func _on_area_2d_body_entered(body):
	if body.return_size() > 2:
		change_hp(body.return_size());
		collisionArray.append({"size": body.return_size(), "type" : body.return_type()});
		if hp <= 0:
			gameOver.emit();
	body.queue_free();
	
func clear_collision_array():
	collisionArray = [];
func change_hp(num):
	hp -= num;
	hpBar.value = hp;
