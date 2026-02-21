extends Control

func _ready():
	$VBoxContainer/PreciseBrush.pressed.connect(_on_ThinBrushButton_pressed)
	$VBoxContainer/SoftBrush.pressed.connect(_on_ThickBrushButton_pressed)
	$VBoxContainer/MediumBrush.pressed.connect(_on_MediumBrushButton_pressed)

func _on_ThinBrushButton_pressed():
	ActiveBrush.current_brush_style = "thin"
	print("Selected brush: thin")

func _on_ThickBrushButton_pressed():
	ActiveBrush.current_brush_style = "thick"
	print("Selected brush: thick")

func _on_MediumBrushButton_pressed():
	ActiveBrush.current_brush_style = "medium"
	print("Selected brush: thick")
