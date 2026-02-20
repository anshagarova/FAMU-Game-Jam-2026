@tool
extends Node2D

@export var brush_color: Color = Color(0.78, 0.12, 0.22, 1.0)
@export var brush_radius: float = 10.0
@export var softness: float = 0.20
@export var bristle_count: int = 50
@export var max_alpha: float = 0.45
@export var spacing: float = 1.0
@export var erase_mode: bool = false

var _canvas: Image
var _texture: ImageTexture
var _sprite: Sprite2D
var _rng := RandomNumberGenerator.new()
var _last_pos: Vector2 = Vector2.INF
var _painting: bool = false

func _ready() -> void:
	_rng.randomize()
	_init_canvas()

func _init_canvas() -> void:
	var vp_size := get_viewport_rect().size
	_canvas = Image.create(int(vp_size.x), int(vp_size.y), false, Image.FORMAT_RGBA8)
	_canvas.fill(Color(0, 0, 0, 0))
	_texture = ImageTexture.create_from_image(_canvas)
	_sprite = Sprite2D.new()
	_sprite.texture = _texture
	_sprite.centered = false
	_sprite.position = Vector2.ZERO
	add_child(_sprite)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_painting = event.pressed
		if _painting:
			_last_pos = Vector2.INF
	if event is InputEventMouseMotion and _painting:
		_try_stamp(event.position)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_stamp(event.position)

func _try_stamp(pos: Vector2) -> void:
	if _last_pos.distance_to(pos) >= spacing or _last_pos == Vector2.INF:
		_stamp(pos)
		_last_pos = pos

func _stamp(center: Vector2) -> void:
	for i in bristle_count:
		var angle := _rng.randf() * TAU

		var t := sqrt(_rng.randf())
		var dist := t * brush_radius

		var rim_t := dist / brush_radius
		var fade_start := 1.0 - softness
		var soft_factor: float
		if rim_t <= fade_start:
			soft_factor = 1.0
		else:
			soft_factor = 1.0 - (rim_t - fade_start) / max(softness, 0.001)

		var alpha := max_alpha * soft_factor
		alpha *= _rng.randf_range(0.85, 1.0)

		if erase_mode:
			alpha = -alpha

		var px := int(center.x + cos(angle) * dist)
		var py := int(center.y + sin(angle) * dist)

		if px < 0 or py < 0 or px >= _canvas.get_width() or py >= _canvas.get_height():
			continue

		var dot_r: int = _rng.randi_range(1, 2)
		_paint_dot(px, py, dot_r, alpha)

	_texture.update(_canvas)

func _paint_dot(cx: int, cy: int, r: int, alpha: float) -> void:
	for dy in range(-r, r + 1):
		for dx in range(-r, r + 1):
			if dx * dx + dy * dy > r * r:
				continue
			var x := cx + dx
			var y := cy + dy
			if x < 0 or y < 0 or x >= _canvas.get_width() or y >= _canvas.get_height():
				continue

			var existing: Color = _canvas.get_pixel(x, y)

			if erase_mode:
				existing.a = clampf(existing.a + alpha, 0.0, 1.0)
				_canvas.set_pixel(x, y, existing)
			else:
				var src_a := clampf(alpha, 0.0, 1.0)
				var dst_a := existing.a
				var out_a := src_a + dst_a * (1.0 - src_a)
				if out_a > 0.0:
					var out_r := (brush_color.r * src_a + existing.r * dst_a * (1.0 - src_a)) / out_a
					var out_g := (brush_color.g * src_a + existing.g * dst_a * (1.0 - src_a)) / out_a
					var out_b := (brush_color.b * src_a + existing.b * dst_a * (1.0 - src_a)) / out_a
					_canvas.set_pixel(x, y, Color(out_r, out_g, out_b, out_a))

func clear() -> void:
	_canvas.fill(Color(0, 0, 0, 0))
	_texture.update(_canvas)
	_last_pos = Vector2.INF
