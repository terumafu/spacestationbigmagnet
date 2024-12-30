extends Control

signal repairButtonSignal;
signal speedUpgradeSignal;
signal weightUpgradeSignal;
signal beamUpgradeSignal;

signal exitMenuSignal;

@export var missionText : Label;
func _on_repairbutton_pressed():
	repairButtonSignal.emit();

func _on_speedbutton_pressed():
	speedUpgradeSignal.emit();
	
func _on_weight_button_pressed():
	weightUpgradeSignal.emit();
	
func _on_beambutton_pressed():
	beamUpgradeSignal.emit();

func _on_exit_pressed():
	exitMenuSignal.emit();

func set_mission_text(string):
	missionText.text = string;


