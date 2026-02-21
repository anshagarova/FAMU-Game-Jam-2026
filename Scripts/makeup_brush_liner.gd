@tool
extends Node2D

@export var max_width: float = 6.0
@export var min_width: float = 1.8
@export var tip_sharpness: float = 0.18
@export var palette: Node

var drawing = false
var strokes = []
var current_stroke = []
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
	if ActiveBrush.current_brush_style != "thin":
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				current_stroke = {
					"points": [],
					"color": brush_color
				}
				current_stroke["points"].append(event.position)
				strokes.append(current_stroke)

	elif event is InputEventMouseMotion and drawing:
		var pts = current_stroke["points"]

		if pts.size() > 0 and pts[-1].distance_to(event.position) < 2.0:
			return

		pts.append(event.position)

		var new_index = pts.size() - 1
		if new_index > 0:
			var a = pts[new_index - 1]
			var b = pts[new_index]

			var t0 = float(new_index - 1) / float(pts.size())
			var t1 = float(new_index) / float(pts.size())

			var w0 = _width_at(t0)
			var w1 = _width_at(t1)

			_stamp_segment(a, b, w0, w1, current_stroke["color"])
			_texture.update(_canvas)

func _stamp_segment(a: Vector2, b: Vector2, w0: float, w1: float, color: Color):
	var dir = (b - a).normalized()
	var perp = dir.rotated(PI / 2)

	var p0 = a + perp * w0 * 0.5
	var p1 = a - perp * w0 * 0.5
	var p2 = b - perp * w1 * 0.5
	var p3 = b + perp * w1 * 0.5

	_draw_triangle(p0, p1, p2, color)
	_draw_triangle(p0, p2, p3, color)

func _draw_triangle(a: Vector2, b: Vector2, c: Vector2, color: Color):

	var min_x = int(floor(min(a.x, b.x, c.x)))
	var max_x = int(ceil(max(a.x, b.x, c.x)))
	var min_y = int(floor(min(a.y, b.y, c.y)))
	var max_y = int(ceil(max(a.y, b.y, c.y)))

	min_x = clamp(min_x, 0, _canvas.get_width())
	max_x = clamp(max_x, 0, _canvas.get_width())
	min_y = clamp(min_y, 0, _canvas.get_height())
	max_y = clamp(max_y, 0, _canvas.get_height())

	var area = _edge(a, b, c)
	if area == 0:
		return

	var sign = 1.0
	if area < 0:
		sign = -1.0

	for y in range(min_y, max_y):
		for x in range(min_x, max_x):
			var p = Vector2(x + 0.5, y + 0.5)

			var w0 = _edge(b, c, p) * sign
			var w1 = _edge(c, a, p) * sign
			var w2 = _edge(a, b, p) * sign

			if w0 >= 0 and w1 >= 0 and w2 >= 0:
				_canvas.set_pixel(x, y, color)
				
func _edge(a: Vector2, b: Vector2, c: Vector2) -> float:
	return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)
	
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
	var taper: float = 0.5
	if t < tip_sharpness:
		taper = t / tip_sharpness
	elif t > 1.0 - tip_sharpness:
		taper = (1.0 - t) / tip_sharpness
	taper = pow(taper, 0.5)
	return min_width + (max_width - min_width) * taper
