extends Control

@export var track_3: AudioStream

var hair_textures = [
	preload("res://Assets/hair/01.png"),
	preload("res://Assets/hair/02.png"),
	preload("res://Assets/hair/03.png"),
	preload("res://Assets/hair/04.png"),
	preload("res://Assets/hair/05.png"),
	preload("res://Assets/hair/06.png"),
]
var current_hair = 0

func _on_dialogue_ended(flags):
	self.visible = true
	var paintingScene = %paintingScene
	paintingScene.visible = true

func _ready():
	var old_player = get_tree().root.get_node_or_null("CarriedMusicPlayer")
	if old_player:
		old_player.queue_free()
	$AudioStreamPlayer2D.stream = track_3
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.finished.connect(func(): $AudioStreamPlayer2D.play())
	self.visible = false
	var paintingScene = %paintingScene
	paintingScene.visible = false
	$FinishButton.pressed.connect(_on_finish_pressed)
	$HairButton.pressed.connect(_on_hair_pressed)
	var resource = load("res://Assets/main_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "bathroom")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_hair_pressed():
	var hair_sprite = %Hair
	hair_sprite.texture = hair_textures[current_hair]
	current_hair = (current_hair + 1) % hair_textures.size()


func _on_finish_pressed():
	var start = Time.get_ticks_msec()
	var canvas_node = %paintingScene/Canvas
	var canvas = canvas_node.image
	# canvas.fill_rect(Rect2i(0, 0, canvas.get_width(), 10),Color(1,0,0,1))
	# canvas.fill_rect(Rect2i(0, canvas.get_height()-10, canvas.get_width(), 10),Color(1,0,0,1))
	# canvas.fill_rect(Rect2i(0, 0, 10, canvas.get_height()),Color(1,0,0,1))
	# canvas.fill_rect(Rect2i(canvas.get_width()-10, 0, 10, canvas.get_height()),Color(1,0,0,1))
	var face_image = load("res://Assets/blank_faces/01_half.png")
	var face_image_new = face_image.duplicate()
	face_image_new.blend_rect(canvas, Rect2i(0, 0, canvas.get_width(), canvas.get_height()), Vector2i(160, 104))
	var final_image = Image.create_empty(1024, 1119, false, Image.FORMAT_RGBA8)
	final_image.blit_rect_mask(face_image_new, face_image, Rect2i(0, 0, 1024, 1119), Vector2i(0, 0))
	var hair_obj = %Hair
	if hair_obj.texture != null:
		var hair_image = hair_obj.texture.get_image()
		hair_image.shrink_x2()
		final_image.blend_rect(hair_image, Rect2i(0, 0, hair_image.get_width(), hair_image.get_height()), Vector2i(0, 0))
	var textureNumber = "0%d" % Global.selectedLevel
	var should_be_image = load("res://Assets/with_makeup/%s.png" % textureNumber).get_image()
	should_be_image.resize(128, 140)
	
	var compare_image = Image.create_empty(1024, 1119, false, Image.FORMAT_RGBA8)
	compare_image.copy_from(final_image)
	compare_image.resize(128, 140)
	var image_metrics = compare_image.compute_image_metrics(should_be_image, false)
	print(image_metrics)

	Global.mean = image_metrics["mean"]
	Global.final_image = final_image
	var end = Time.get_ticks_msec()
	print("Image processing took %d ms" % (end-start))
	var scene_path = "res://Scenes/End_scene.tscn"
	print("Button pressed → Changing to:", scene_path)
	get_tree().change_scene_to_file(scene_path)
