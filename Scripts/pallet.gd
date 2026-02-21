extends Control

signal color_changed(color: Color)
signal clear_requested()

@export var colors: Array[Color] = [
	Color(0.78, 0.12, 0.22),
	Color(0.55, 0.08, 0.25),
	Color(0.90, 0.35, 0.40),
	Color(0.10, 0.05, 0.80)
]

var _active_index: int = 0
var _swatches: Array = []

func _ready():
	print("ColorPalette _ready fired")
	_init_ui()

func _init_ui():
	const SWATCH_SIZE = 36
	const SWATCH_PAD  = 4

	for i in range(colors.size()):
		var swatch = Panel.new()
		swatch.custom_minimum_size = Vector2(SWATCH_SIZE, SWATCH_SIZE)
		swatch.size = Vector2(SWATCH_SIZE, SWATCH_SIZE)
		swatch.position = Vector2(i * (SWATCH_SIZE + SWATCH_PAD), 0)
		swatch.mouse_filter = Control.MOUSE_FILTER_STOP  # stop clicks here

		var preview = ColorRect.new()
		preview.color = colors[i]
		preview.size = Vector2(SWATCH_SIZE - 4, SWATCH_SIZE - 4)
		preview.position = Vector2(2, 2)
		preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		swatch.add_child(preview)

		swatch.connect("gui_input", _on_swatch_input.bind(i))

		add_child(swatch)
		_swatches.append(swatch)

	_select_swatch(0)

func _on_swatch_input(event: InputEvent, index: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Swatch clicked: ", index)
		_select_swatch(index)

func _select_swatch(index: int):
	_active_index = index

	for i in range(_swatches.size()):
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0, 0, 0, 0)
		if i == index:
			style.border_width_top    = 2
			style.border_width_left   = 2
			style.border_width_right  = 2
			style.border_width_bottom = 2
			style.border_color = Color(1, 1, 1)
		else:
			style.border_width_top    = 1
			style.border_width_left   = 1
			style.border_width_right  = 1
			style.border_width_bottom = 1
			style.border_color = Color(0.2, 0.2, 0.2)
		_swatches[i].add_theme_stylebox_override("panel", style)

	color_changed.emit(colors[index])
	print("Selected color: ", colors[index])
