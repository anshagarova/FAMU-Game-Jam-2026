extends Control

func _ready():
	$PlayAsPlayer1.pressed.connect(_on_play1_pressed)
	$PlayAsPlayer2.pressed.connect(_on_play2_pressed)
	$Menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Quit.pressed.connect(_on_quit_pressed)

func _on_play1_pressed():
	var scene_path = "res://Scenes/Play_as_player1.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)

func _on_play2_pressed():
	var scene_path = "res://Scenes/Play_as_player2.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
	
func _on_quit_pressed():
	get_tree().quit()
