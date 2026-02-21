extends Control

func _ready():
	$HBoxContainer/FinishButton.pressed.connect(_on_finish_pressed)

func _on_finish_pressed():
	var brush = %paintingScene/Brush
	var canvas = brush._canvas
	print("Canvas size", canvas.get_size())
	canvas.save_png("test.png")
	var face_image = load("res://Assets/blank_faces/01.png").get_image()
	face_image.resize(1080, 1080)
	var center_start = (canvas.get_width() / 2) - (face_image.get_width() / 2)
	var face_image_new = face_image.duplicate()
	face_image_new.blend_rect(canvas, Rect2i(center_start, 0, face_image.get_width(), face_image.get_height()), Vector2(0, 0))
	var final_image = Image.create_empty(1080, 1080, false, Image.FORMAT_RGBA8)
	final_image.blit_rect_mask(face_image_new, face_image, Rect2i(0, 0, 1080, 1080), Vector2(0, 0))
	# canvas.blend_rect(face_image, Rect2i(0, 0, face_image.get_width(), face_image.get_height()), Vector2(center_start, 0))
	# canvas.save_png("test_blend.png")
	final_image.save_png("test_blend.png")
	var should_be_image = load("res://Assets/with_makeup/01.png").get_image()
	var image_metrics = final_image.compute_image_metrics(should_be_image, false)
	print(image_metrics)
	Global.final_image = final_image
	var scene_path = "res://Scenes/End_scene.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
