extends Control

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
	var scene_path = "res://Scenes/Choose_player_menu.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
