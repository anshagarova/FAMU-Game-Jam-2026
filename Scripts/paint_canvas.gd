extends Node2D

var image: Image
var texture: ImageTexture
var sprite: Sprite2D
signal canvas_ready

const CANVAS_WIDTH = 755
const CANVAS_HEIGHT = 950
var canvas_offset: Vector2

func _ready():
	var vp_size = get_viewport_rect().size
	
	canvas_offset = Vector2i(
		(vp_size.x - CANVAS_WIDTH) / 2.0+25,
		(vp_size.y - CANVAS_HEIGHT) / 2.0
	)
	
	image = Image.create(CANVAS_WIDTH, CANVAS_HEIGHT, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	texture = ImageTexture.create_from_image(image)
	
	sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = canvas_offset
	add_child(sprite)
	
	emit_signal("canvas_ready")

func update_texture():
	texture.update(image)

func clear():
	image.fill(Color(0, 0, 0, 0))
	update_texture()

func to_canvas_coords(screen_pos: Vector2) -> Vector2:
	return screen_pos - canvas_offset
