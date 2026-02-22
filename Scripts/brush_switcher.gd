extends Control

func _ready():
	$PreciseBrush.pressed.connect(_on_ThinBrushButton_pressed)
	$SoftBrush.pressed.connect(_on_ThickBrushButton_pressed)
	$MediumBrush.pressed.connect(_on_MediumBrushButton_pressed)

func _on_ThinBrushButton_pressed():
	ActiveBrush.current_brush_style = "thin"
	$PreciseBrush.visible = false
	$SoftBrush.visible = true
	$MediumBrush.visible = true
	print("Selected brush: thin")

func _on_ThickBrushButton_pressed():
	ActiveBrush.current_brush_style = "thick"
	$PreciseBrush.visible = true
	$SoftBrush.visible = false
	$MediumBrush.visible = true
	print("Selected brush: thick")

func _on_MediumBrushButton_pressed():
	ActiveBrush.current_brush_style = "medium"
	$PreciseBrush.visible = true
	$SoftBrush.visible = true
	$MediumBrush.visible = false
	print("Selected brush: thick")
