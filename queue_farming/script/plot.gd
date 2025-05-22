extends Sprite2D

var index: int = -1
var selected: bool = false
@onready var debug: Label = %debug


func init(idx: int) -> void:
	self.index = idx

func _redrawDebug() -> void:
	debug.text = "idx: " + str(index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_redrawDebug()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
