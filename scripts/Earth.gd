extends Node2D
var hp = 100;
@export var hpBar : TextureProgressBar;
func _on_area_2d_body_entered(body):
	if body.return_size() > 2:
		change_hp(body.return_size());
		
	body.queue_free();
	

func change_hp(num):
	hp -= num;
	hpBar.value = hp;
