extends Node2D

var drawing = false
var strokes = []
var current_stroke = []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				current_stroke = []
				current_stroke.append(event.position)
				strokes.append(current_stroke)
	if event is InputEventMouseMotion and drawing:
		current_stroke.append(event.position)
		queue_redraw()

func _draw():
	return
	var width = 3.0
	var color = Color.BLACK
	for stroke in strokes:
		if stroke.size() == 1:
			draw_circle(stroke[0], width / 2.0, color)
			continue
		draw_polyline(stroke, color, width, true)
		draw_circle(stroke[0], width / 2.0, color)
		draw_circle(stroke[-1], width / 2.0, color)
