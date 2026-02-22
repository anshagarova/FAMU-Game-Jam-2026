extends Control

func _on_hair_one_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/01.png")
	
func _on_hair_two_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/02.png")
	
func _on_hair_three_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/03.png")
	
func _on_hair_four_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/04.png")
	
func _on_hair_five_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/05.png")

func _on_hair_six_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = load("res://Assets/hair/06.png")

func _on_dialogue_ended(flags):
	self.visible = true
	var paintingScene = %paintingScene
	paintingScene.visible = true

func _ready():
	var root = get_tree().root
	for child in root.get_children():
		if child is AudioStreamPlayer:
			child.queue_free()
	self.visible = false
	var paintingScene = %paintingScene
	paintingScene.visible = false
	$HBoxContainer/FinishButton.pressed.connect(_on_finish_pressed)
	$Hair1Button.pressed.connect(_on_hair_one_pressed)
	$Hair2Button.pressed.connect(_on_hair_two_pressed)
	$Hair3Button.pressed.connect(_on_hair_three_pressed)
	$Hair4Button.pressed.connect(_on_hair_four_pressed)
	$Hair5Button.pressed.connect(_on_hair_five_pressed)
	$Hair6Button.pressed.connect(_on_hair_six_pressed)
	var resource = load("res://Assets/main_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "bathroom")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_finish_pressed():
	var brush = %paintingScene/ThinBrush
	var canvas = brush._canvas
	var brush_medium = %paintingScene/SoftBrush
	var canvas_medium = brush_medium._canvas
	var brush_soft = %paintingScene/MediumBrush
	var canvas_soft = brush_soft._canvas
	print("Canvas size", canvas.get_size())
	var face_image = load("res://Assets/blank_faces/01.png").get_image()
	face_image.resize(1080, 1080, Image.Interpolation.INTERPOLATE_CUBIC)
	var center_start = (canvas.get_width() / 2) - (face_image.get_width() / 2)
	var face_image_new = face_image.duplicate()
	face_image_new.blend_rect(canvas_medium, Rect2i(center_start, 40, face_image.get_width(), face_image.get_height()), Vector2i(0, 0))
	face_image_new.blend_rect(canvas_soft, Rect2i(center_start, 40, face_image.get_width(), face_image.get_height()), Vector2i(0, 0))
	face_image_new.blend_rect(canvas, Rect2i(center_start, 40, face_image.get_width(), face_image.get_height()), Vector2i(0, 0))
	var final_image = Image.create_empty(1080, 1080, false, Image.FORMAT_RGBA8)
	final_image.blit_rect_mask(face_image_new, face_image, Rect2i(0, 0, 1080, 1080), Vector2i(0, 0))
	var hair_obj = %Hair
	if hair_obj.texture != null:
		var hair_image = hair_obj.texture.get_image()
		hair_image.resize(1080, 1180, Image.Interpolation.INTERPOLATE_CUBIC)
		final_image.blend_rect(hair_image, Rect2i(0, 0, hair_image.get_width(), hair_image.get_height()), Vector2i(0, -100))
	var should_be_image = load("res://Assets/with_makeup/01.png").get_image()
	should_be_image.resize(1080, 1080, Image.Interpolation.INTERPOLATE_CUBIC)
	var image_metrics = final_image.compute_image_metrics(should_be_image, false)
	print(image_metrics)
	Global.mean = image_metrics["mean"]
	Global.final_image = final_image
	var scene_path = "res://Scenes/End_scene.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
