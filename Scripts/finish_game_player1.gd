extends Control

func _ready():
	$HBoxContainer/FinishButton.pressed.connect(_on_finish_pressed)

func _on_finish_pressed():
	var scene_path = "res://Scenes/End_scene.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
