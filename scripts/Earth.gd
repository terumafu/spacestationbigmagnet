extends Node2D

@export var hpBar : TextureProgressBar;
@export var sprite : Sprite2D;
var collisionArray = []
var hp = 100;
signal gameOver;
var timePassed = 0;
func _process(delta):
	sprite.position[1] = 7 * sin(timePassed * 1.2);
	timePassed += delta;
func _on_area_2d_body_entered(body):
	if body.return_size() > 2:
		change_hp(body.return_size());
		collisionArray.append({"size": body.return_size(), "type" : body.return_type()});
		if hp <= 0:
			gameOver.emit();
	body.call_deferred("queue_free");
	
func clear_collision_array():
	collisionArray = [];
func change_hp(num):
	hp -= num;
	hpBar.value = hp;
	var tween = get_tree().create_tween();
	tween.tween_property(self,"modulate", Color.RED,0.2);
	tween.chain().tween_property(self,"modulate", Color.WHITE,0.5)
