@tool
extends Node2D
var drawing = false
var strokes = []
var current_stroke = []
@export var max_width: float = 6.0
@export var min_width: float = 0.0
@export var tip_sharpness: float = 0.18
@export var palette: Node
var brush_color: Color = Color.RED
var _canvas: Image
var _texture: ImageTexture
var _sprite: Sprite2D

func _init_canvas():
	var vp_size = get_viewport_rect().size
	_canvas = Image.create(int(vp_size.x), int(vp_size.y), false, Image.FORMAT_RGBA8)
	_canvas.fill(Color(0, 0, 0, 0))
	_texture = ImageTexture.create_from_image(_canvas)
	_sprite = Sprite2D.new()
	_sprite.texture = _texture
	_sprite.centered = false
	_sprite.position = Vector2.ZERO
	add_child(_sprite)

func _ready():
	_init_canvas()
	var mat = CanvasItemMaterial.new()
	mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	material = mat
	modulate = Color(1, 1, 1, 1)
	if palette != null:
		palette.color_changed.connect(func(c: Color):
			brush_color = c
		)
		print("Connected to palette")
	else:
		push_warning("No palette assigned")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				current_stroke = {
					"points": [],
					"color": brush_color
				}
				print("Drawing with color:", brush_color)
				current_stroke["points"].append(event.position)
				strokes.append(current_stroke)
				print("Node modulate:", modulate)
			else:

				_process_strokes()
	if event is InputEventMouseMotion and drawing:
		current_stroke["points"].append(event.position)

		_process_strokes()
		queue_redraw()

func _stamp_segment(a: Vector2, b: Vector2, w0: float, w1: float, color: Color):
	var dir = (b - a).normalized()
	var perp = dir.rotated(PI / 2)
	var p0 = a + perp * w0 * 0.5
	var p1 = a - perp * w0 * 0.5
	var p2 = b - perp * w1 * 0.5
	var p3 = b + perp * w1 * 0.5
	_draw_polygon_to_canvas(PackedVector2Array([p0, p3, p2, p1]), color)
	_texture.update(_canvas)

func _draw_polygon_to_canvas(poly: PackedVector2Array, color: Color):
	var min_x = int(poly[0].x)
	var min_y = int(poly[0].y)
	var max_x = int(poly[0].x)
	var max_y = int(poly[0].y)
	for p in poly:
		min_x = min(min_x, int(p.x))
		min_y = min(min_y, int(p.y))
		max_x = max(max_x, int(p.x))
		max_y = max(max_y, int(p.y))

	for y in range(min_y, max_y):
		for x in range(min_x, max_x):

			if _point_in_polygon(Vector2(x, y), poly):
				if x >= 0 and y >= 0 and x < _canvas.get_width() and y < _canvas.get_height():
					_canvas.set_pixel(x, y, color)

func _point_in_polygon(p: Vector2, poly: PackedVector2Array) -> bool:
	var inside = false
	var j = poly.size() - 1
	for i in range(poly.size()):
		if ((poly[i].y > p.y) != (poly[j].y > p.y)) and (p.x < (poly[j].x - poly[i].x) * (p.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x):
			inside = not inside
		j = i
	return inside

func _process_strokes():
	for stroke in strokes:
		var pts = stroke["points"]
		var color = stroke["color"]
		if pts.size() < 2:
			continue
		for i in range(pts.size() - 1):
			var a = pts[i]
			var b = pts[i + 1]
			var t0 = float(i) / float(pts.size() - 1)
			var t1 = float(i + 1) / float(pts.size() - 1)
			var w0 = _width_at(t0)
			var w1 = _width_at(t1)
			_stamp_segment(a, b, w0, w1, color)

func _width_at(t: float) -> float:
	var taper: float = 1.0
	if t < tip_sharpness:
		taper = t / tip_sharpness
	elif t > 1.0 - tip_sharpness:
		taper = (1.0 - t) / tip_sharpness
	taper = pow(taper, 2.0)
	return min_width + (max_width - min_width) * taper
