class_name FloatingText extends Marker2D

@onready var label = $Label
var tween: Tween

@export var duration: float = 1.0
@export var text: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text
	
	tween = create_tween().set_parallel(true)
	tween.pause()

func start():
	tween.chain().tween_callback(self.queue_free)
	tween.play()

func m_position(s: Vector2, e: Vector2):
	position = s
	tween.tween_property(self, "position", e, duration)
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
