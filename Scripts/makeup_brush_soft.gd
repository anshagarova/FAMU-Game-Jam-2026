@tool
extends Node2D

@export var canvas_node: Node
var _canvas: Image

@export var brush_radius: float = 30.0
@export var softness: float = 0.85
@export var bristle_count: int = 120
@export var max_alpha: float = 0.08
@export var spacing: float = 3.0
@export var erase_mode: bool = false
@export var palette: Node

var _rng := RandomNumberGenerator.new()
var _last_pos: Vector2 = Vector2.INF
var _painting: bool = false
var brush_color: Color = Color(0.85, 0.4, 0.55, 1.0)

func _ready() -> void:
	_rng.randomize()

	if canvas_node == null:
		push_error("Canvas node not assigned!")
		return

	if canvas_node.image == null:
		await canvas_node.canvas_ready

	_canvas = canvas_node.image
	
	if palette != null:
		palette.color_changed.connect(func(c: Color):
			brush_color = c
		)
	
func _input(event: InputEvent) -> void:
	if ActiveBrush.current_brush_style != "thick":
			return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_painting(event.position)
			else:
				stop_painting()
	elif event is InputEventMouseMotion:
		paint_motion(event.position)

func set_brush_color(c: Color):
	brush_color = c

func set_erase_mode(active: bool):
	erase_mode = active

func start_painting(pos: Vector2):
	_painting = true
	_last_pos = Vector2.INF
	_try_stamp(pos)

func stop_painting():
	_painting = false

func paint_motion(pos: Vector2):
	if _painting:
		_try_stamp(pos)

func _try_stamp(pos: Vector2):
	if _last_pos.distance_to(pos) >= spacing or _last_pos == Vector2.INF:
		_stamp(pos)
		_last_pos = pos

func _stamp(center: Vector2):
	for i in bristle_count:
		var angle = _rng.randf() * TAU
		var t = sqrt(_rng.randf())
		var dist = t * brush_radius
		var rim_t = dist / brush_radius
		var fade_start = 1.0 - softness
		var soft_factor = 1.0 if rim_t <= fade_start else 1.0 - (rim_t - fade_start)/max(softness, 0.001)
		var alpha = max_alpha * soft_factor * _rng.randf_range(0.85, 1.0)
		if erase_mode:
			alpha = -alpha
		var px = int(center.x + cos(angle) * dist)
		var py = int(center.y + sin(angle) * dist)
		if px < 0 or py < 0 or px >= _canvas.get_width() or py >= _canvas.get_height():
			continue
		_paint_dot(px, py, _rng.randi_range(1, 2), alpha)
	canvas_node.update_texture()

func _paint_dot(cx: int, cy: int, r: int, alpha: float):
	for dy in range(-r, r+1):
		for dx in range(-r, r+1):
			if dx*dx + dy*dy > r*r:
				continue
			var x = cx + dx
			var y = cy + dy
			if x < 0 or y < 0 or x >= _canvas.get_width() or y >= _canvas.get_height():
				continue
			var existing: Color = _canvas.get_pixel(x, y)
			if erase_mode:
				existing.a = clampf(existing.a + alpha, 0.0, 1.0)
				_canvas.set_pixel(x, y, existing)
			else:
				var src_a = clampf(alpha, 0.0, 1.0)
				var dst_a = existing.a
				var out_a = src_a + dst_a * (1.0 - src_a)
				if out_a > 0.0:
					var out_r = (brush_color.r * src_a + existing.r * dst_a * (1.0 - src_a))/out_a
					var out_g = (brush_color.g * src_a + existing.g * dst_a * (1.0 - src_a))/out_a
					var out_b = (brush_color.b * src_a + existing.b * dst_a * (1.0 - src_a))/out_a
					_canvas.set_pixel(x, y, Color(out_r, out_g, out_b, out_a))

func clear():
	_canvas.fill(Color(0,0,0,0))
	canvas_node.update_texture()
	_last_pos = Vector2.INF
