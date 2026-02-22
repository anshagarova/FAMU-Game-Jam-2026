extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var textureNumber = "0%d" % Global.selectedLevel
	self.texture = load("res://Assets/with_makeup/%s.png" % textureNumber)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
