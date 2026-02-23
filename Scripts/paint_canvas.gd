extends Node2D

var image: Image
var texture: ImageTexture
var sprite: Sprite2D

signal canvas_ready

func _ready():
	var vp_size = get_viewport_rect().size
	image = Image.create(int(vp_size.x), int(vp_size.y), false, Image.FORMAT_RGBA8)
	image.fill(Color(0,0,0,0))

	texture = ImageTexture.create_from_image(image)

	sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	add_child(sprite)

	emit_signal("canvas_ready")
	
func update_texture():
	texture.update(image)

func clear():
	image.fill(Color(0,0,0,0))
	update_texture()
