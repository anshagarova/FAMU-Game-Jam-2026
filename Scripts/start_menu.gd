extends Control

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_button_pressed)
	
func _on_dialogue_ended(flags):
	var scene_path = "res://Scenes/Choose_player_menu.tscn"
	get_tree().change_scene_to_file(scene_path)
	

func _on_play_button_pressed():
	var resource = load("res://Assets/main_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
