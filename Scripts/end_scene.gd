extends Node2D

var small_font = FontFile.new()

func _on_file_selected(path) -> void:
	print(path)
	Global.final_image.save_png(path)
	
func _on_save_pressed() -> void:
	var file_dialog = $FileDialog
	file_dialog.mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.filters = ["*.png"]
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	file_dialog.popup_centered_ratio()

func _ready() -> void:
	$PercentageDisplay.anchor_left = 0.0
	$PercentageDisplay.anchor_right = 1.0
	$PercentageDisplay.anchor_top = 0.0
	$PercentageDisplay.anchor_bottom = 0.0
	$PercentageDisplay.offset_left = 200.0
	$PercentageDisplay.offset_right = 0.0
	$PercentageDisplay.offset_top = 900.0
	$PercentageDisplay.offset_bottom = 0.0
	$Sprite2D.texture = ImageTexture.create_from_image(Global.final_image)
	$SaveImageButton.pressed.connect(_on_save_pressed)
	
	var percentage = (1 - (Global.mean / 20)) * 100
	percentage = max(percentage, 0)
	
	small_font = load("res://Assets/Blue Winter.ttf")
	$PercentageDisplay.add_theme_font_override("font", small_font)
	$PercentageDisplay.add_theme_color_override("font_color", Color.HOT_PINK)
	$PercentageDisplay.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$PercentageDisplay.text = "You got it %d%% right!" % percentage

func _process(delta: float) -> void:
	pass
