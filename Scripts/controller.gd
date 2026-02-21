extends Node2D

@export var brush_node: NodePath
var brush: Node = null

func _ready():
	brush = get_node(brush_node)

func _input(event):
	if not brush:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			brush.start_painting(event.position)
		else:
			brush.stop_painting()
	elif event is InputEventMouseMotion:
		brush.paint_motion(event.position)
