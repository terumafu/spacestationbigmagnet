extends Node2D
#MainScene controls the waves
@export var spawner : Node;
var waveArray = [
	{"name": "first wave",
	"debris": [10,5], #[rocks, gold]
	"probability": [1,1,1,1,1], #[size1, size2, ...]
	"speed": Vector2(randi_range(100,300),randi_range(-20,20)),
	"spawnTime": 3,
	},
	{"name": "electric boogaloo",
	"debris": [5,30], #[rocks, gold]
	"probability": [1,1,1,1,1], #[size1, size2, ...]
	"speed": Vector2(randi_range(100,300),randi_range(-20,20)),
	"spawnTime": 1,
	},
]

func _ready():
	spawn_wave();

func spawn_wave():
	if waveArray.size() == 0:
		print("empty")
		return;
	var waveDict = waveArray.pop_front();
	#set_title(waveDict.name);
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
			tempdict["speed"] = waveDict.speed;
			spawnArr.append(tempdict);
	spawnArr.shuffle()
	spawner.set_wave(spawnArr,waveDict.spawnTime);
	print(spawnArr)


func _on_spawner_wave_complete_signal():
	spawn_wave();
