extends Control

var playing_as = "p1"

func _on_level1_pressed():
	Global.selectedLevel = 1
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_level2_pressed():
	Global.selectedLevel = 2
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_level3_pressed():
	Global.selectedLevel = 3
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_level4_pressed():
	Global.selectedLevel = 4
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_level5_pressed():
	Global.selectedLevel = 5
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)
	
func _on_level6_pressed():
	Global.selectedLevel = 6
	var scene_path
	if playing_as == "p2":
		scene_path = "res://Scenes/Play_as_player2.tscn"
	else:
		scene_path = "res://Scenes/Play_as_player1.tscn"
	get_tree().change_scene_to_file(scene_path)

func _ready():
	$LevelSelect/Button01.pressed.connect(_on_level1_pressed)
	$LevelSelect/Button02.pressed.connect(_on_level2_pressed)
	$LevelSelect/Button03.pressed.connect(_on_level3_pressed)
	$LevelSelect/Button04.pressed.connect(_on_level4_pressed)
	$LevelSelect/Button05.pressed.connect(_on_level5_pressed)
	$LevelSelect/Button06.pressed.connect(_on_level6_pressed)
	
	$PlayAsPlayer1.pressed.connect(_on_play1_pressed)
	$PlayAsPlayer2.pressed.connect(_on_play2_pressed)
	$Menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Quit.pressed.connect(_on_quit_pressed)

func _on_play1_pressed():
	$LevelSelect.visible = true
	playing_as = "p1"

func _on_play2_pressed():
	$LevelSelect.visible = true
	playing_as = "p2"
	
func _on_quit_pressed():
	get_tree().quit()
