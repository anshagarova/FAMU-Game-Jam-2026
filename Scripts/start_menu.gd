extends Control

@onready var music_player = $AudioStreamPlayer2D
@onready var picture = $Picture

@export var track_1: AudioStream
@export var track_2: AudioStream

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_button_pressed)
	music_player.stream = track_1
	music_player.play()
	picture.hide()

func _on_play_button_pressed():
	picture.show()
	music_player.stream = track_2
	music_player.play()
	
	$VBoxContainer/PlayButton.visible = false
	
	var resource = load("res://Assets/main_dialogue.dialogue")

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	DialogueManager.show_dialogue_balloon(resource, "start")
	
func _on_dialogue_ended(flags):
	picture.hide()
	get_tree().change_scene_to_file("res://Scenes/Choose_player_menu.tscn")
