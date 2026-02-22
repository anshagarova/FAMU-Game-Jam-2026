extends Control

@export var track_3: AudioStream

func _ready():
	var old_player = get_tree().root.get_node_or_null("CarriedMusicPlayer")
	if old_player:
		old_player.queue_free()
	$AudioStreamPlayer2D.stream = track_3
	$AudioStreamPlayer2D.play()
	$HBoxContainer/FinishButton.pressed.connect(_on_finish_pressed)
	var resource = load("res://Assets/main_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "bathroom")

func _on_finish_pressed():
	var scene_path = "res://Scenes/End_scene_player1.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
