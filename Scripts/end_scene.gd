extends Node2D

func _on_file_selected(path) -> void:
	print(path)
	Global.final_image.save_png(path)
	

func _on_save_pressed() -> void:
	var file_dialog = $FileDialog
	file_dialog.mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.filters = ["*.png"]
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	file_dialog.popup_centered_ratio()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = ImageTexture.create_from_image(Global.final_image)
	$SaveImageButton.pressed.connect(_on_save_pressed)
	var percentage = (1 - (Global.mean/20)) * 100
	percentage = max(percentage, 0)
	print(percentage)
	$PercentageDisplay.text = "You got it %d%% right!" % percentage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
