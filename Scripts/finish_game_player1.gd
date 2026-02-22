extends Control

func _ready():
	$HBoxContainer/FinishButton.pressed.connect(_on_finish_pressed)
	var resource = load("res://Assets/main_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "bathroom")

func _on_finish_pressed():
	var scene_path = "res://Scenes/End_scene_player1.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
