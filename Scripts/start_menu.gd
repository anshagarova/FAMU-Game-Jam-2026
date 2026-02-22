extends Control

@onready var music_player = $AudioStreamPlayer2D
@onready var picture = $Picture

@export var track_1: AudioStream
@export var track_2: AudioStream

func _ready():
	$PlayButton.pressed.connect(_on_play_button_pressed)

	if music_player.get_parent() != get_tree().root:
		music_player.get_parent().remove_child(music_player)
		music_player.name = "CarriedMusicPlayer"
		get_tree().root.call_deferred("add_child", music_player)

	call_deferred("_start_music")

	picture.hide()

func _start_music():
	if music_player.stream != track_1:
		music_player.stream = track_1
		music_player.play()

func _on_play_button_pressed():
	picture.show()
	
	if music_player.stream != track_2:
		music_player.stream = track_2
		music_player.play()
	
	$PlayButton.visible = false
	
	var resource = load("res://Assets/main_dialogue.dialogue")
	
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	DialogueManager.show_dialogue_balloon(resource, "start")

func _on_dialogue_ended(flags):
	picture.hide()
	get_tree().change_scene_to_file("res://Scenes/Choose_player_menu.tscn")
