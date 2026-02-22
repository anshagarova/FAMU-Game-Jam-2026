extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var textureNumber = "0%d" % Global.selectedLevel
	var resource = "res://Assets/with_makeup/%s.png" % textureNumber
	print("loading resource ", resource)
	self.texture = load(resource)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
