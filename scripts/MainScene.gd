extends Node2D
#MainScene controls the waves
var menu = preload("res://scenes/upgradeMenu.tscn");

@export var spawner : Node;
@export var camera : Camera2D;
@export var menuPosition : Control;
@export var spaceStation : Node2D;
@export var magnet : Node2D;
@export var earth : Node2D;
@export var missionStatement : Label;
@export var waveName : Label;
@export var gameOver : Label;
@export var gameWin : Label;
@export var controls : Control;
var cameraLocation;
var currentMission;
var waveArray = [
	{"name": "the first wave",
	"debris": [10,5], #[rocks, gold]
	"probability": [1,1,1,1,1], #[size1, size2, ...]
	"speed": func callable(): return Vector2(randi_range(100,300),randi_range(-20,20)),
	"spawnTime": 3, # 45 seconds
	},
	{"name": "electric boogaloo",
	"debris": [5,30], #[rocks, gold]
	"probability": [1,1,1,1,1], #[size1, size2, ...]
	"speed": func callable(): return Vector2(randi_range(100,300),randi_range(-20,20)),
	"spawnTime": 1, # 35 econds
	},{"name": "blink and you'll miss it",
	"debris": [10,10], #[rocks, gold]
	"probability": [1,0,1,0,0], #[size1, size2, ...]
	"speed": func callable(): return Vector2(randi_range(200,400),randi_range(-30,30)),
	"spawnTime": 1.5, # 30 seconds
	},{"name": "big and slow",
	"debris": [15,5],
	"probability": [0,0,1,1,1], #[size1, size2, ...]
	"speed": func callable(): return Vector2(randi_range(100,250),randi_range(-20,20)),
	"spawnTime": 2, # 40 seconds
	},{"name": "curveballs",
	"debris": [15,15],
	"probability": [1,1,1,1,1], #[size1, size2, ...]
	"speed": func callable(): return Vector2(randi_range(200,400), 100 * randi_range(-3,3)),
	"spawnTime": 1, # 30 seconds
	}
]
var missionArray = [
	{
		"description": 
			"the big cheese wants some of the gold we've been harvesting, 
			let 2 big gold meteors hit earth. 
			Don't worry about the civilians, we'll handle it.",
		"shortText": "let 2 big gold meteors hit earth",
		"checkCallable": 
			func callable(): 
				var sum = 0;
				for n in earth.collisionArray:
					if n.type == 1:
						sum += 1;
				if sum >= 2:
					spaceStation.change_money(10);,
	},{
		"description":
			"we're short on funds, collect at least 5 pieces of gold and we'll give you a bonus",
		"shortText": "collect 5 pieces of gold",
		"checkCallable": 
			func callable():
				var sum = 0;
				for n in spaceStation.rocksCollected:
					if n.type == 1:
						sum += 1;
				if sum >= 5:
					spaceStation.change_money(3);,
	},{
		"description":
			"this next wave contains rocks rich in minerals that have research importance.
			collect 15 weight worth of rocks and we'll reward you handsomely.",
		"shortText": "collect 15 weight",
		"checkCallable":
			func callable():
				if spaceStation.weight >= 15:
					spaceStation.change_money(5);,
	},{
		"description":
			"We need to be in good shape for the next mission, 
			end this wave with more than 50% hp, 
			If you fail we will lose all of our cash. Please do not fail.",
		"shortText":"end the wave with more than 50% health",
		"checkCallable":
			func callable():
				if spaceStation.hp >= 50:
					spaceStation.change_hp(100);
				else:
					spaceStation.money = 0;
					spaceStation.change_money(0);,
	}
]
signal gameReset;
func _ready():
	get_tree().paused = true;
	missionArray.shuffle();
	#await get_tree().create_timer(0.1).timeout
	#transition_to_break()
	spawn_wave();
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if controls.visible == false && get_tree().paused == true:
			return;
		if controls.visible == false:
			get_tree().paused = true;
		if controls.visible == true:
			get_tree().paused = false;
		controls.visible = !controls.visible;
func spawn_wave():
	if waveArray.size() == 0:
		print("empty")
		return;
	var waveDict = waveArray.pop_front();
	
	#set wave and mission text
	waveName.text = waveDict.name;
	waveName.visible = true; # this could be a tween
	
	if currentMission != null:
		missionStatement.text = currentMission.shortText;
		missionStatement.visible = true; #this could be a tween
	var probabilityArr = [];
	var spawnArr = [];
	for stakes in waveDict.probability.size():
		for n in waveDict.probability[stakes]:
			probabilityArr.append(stakes + 1);
	for reps in waveDict.debris.size():
		for n in waveDict.debris[reps]:
			var tempdict = {};
			tempdict["type"] = reps;
			tempdict["size"] = probabilityArr[randi_range(0, probabilityArr.size() - 1)];
			tempdict["speed"] = waveDict.speed.call();
			spawnArr.append(tempdict);
	spawnArr.shuffle()
	spawner.set_wave(spawnArr,waveDict.spawnTime);
	#print(spawnArr)

func _on_spawner_transition_break_signal():
	waveName.visible = false; # this could be a tween
	transition_to_break();

func transition_to_break():
	cameraLocation = camera.global_position;
	get_tree().paused = true;
	var tween = get_tree().create_tween().set_parallel(true);
	tween.set_pause_mode(2);
	tween.tween_property(camera, "zoom", Vector2(2,2), 2).set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property(camera, "global_position",$SpaceStation.global_position + Vector2(400,0) , 2).set_trans(Tween.TRANS_SINE)
	await tween.finished
	spawn_upgrade_menu();
	pass

func spawn_upgrade_menu():
	#checks if current mission is fulfilled
	check_mission();
	#resets weight;
	spaceStation.weight = 0;
	spaceStation.change_weight(0);
	
	var temp = menu.instantiate();
	
	#set current mission;
	if missionArray.size() > 0:
		currentMission = missionArray.pop_front();
		temp.set_mission_text(currentMission.description);
	else:
		print("game win!");
		game_win();
		return;
		
	menuPosition.global_position = Vector2(1152/2,75);
	menuPosition.call_deferred("add_child",temp);
	temp.repairButtonSignal.connect(repairShip);
	temp.speedUpgradeSignal.connect(upgradeSpeed);
	temp.weightUpgradeSignal.connect(upgradeWeight);
	temp.beamUpgradeSignal.connect(upgradeBeam);
	temp.exitMenuSignal.connect(exit_menu);
	
func check_mission():
	if currentMission != null:
		currentMission.checkCallable.call();
		missionStatement.visible = false; # this could be a tween
func repairShip():
	if spaceStation.money >= 1 && spaceStation.hp < 100:
		spaceStation.change_hp(10);
		spaceStation.change_money(-1);
func upgradeSpeed():
	if spaceStation.money >= 2:
		spaceStation.speed += 0.1;
		spaceStation.change_money(-2);
func upgradeWeight():
	if spaceStation.money >= 2:
		spaceStation.change_max_weight(5);
		spaceStation.change_money(-2);
func upgradeBeam():
	if spaceStation.money >= 4:
		magnet.powerMult += 0.1;
		spaceStation.change_money(-4);
		
func exit_menu():
	spaceStation.rocksCollected = [];
	earth.clear_collision_array();
	menuPosition.get_child(0).call_deferred("queue_free");
	var tween = get_tree().create_tween().set_parallel(true);
	tween.set_pause_mode(2);
	tween.tween_property(camera, "zoom", Vector2(1,1), 2).set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property(camera, "global_position",cameraLocation, 2).set_trans(Tween.TRANS_SINE)
	await tween.finished
	get_tree().paused = false;
	#back to game!
	spawn_wave();

func game_over():
	#game is over
	get_tree().paused = true;
	gameOver.visible = true;
	pass

func game_win():
	get_tree().paused = true;
	gameWin.visible = true;


func _on_button_pressed():
	gameReset.emit(self);
