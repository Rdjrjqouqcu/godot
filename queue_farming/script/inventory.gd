extends VBoxContainer


func _ready() -> void:
	for child in get_children():
		child.queue_free()
	for i in range(1,50+1):
		var n = Label.new()
		n.text = str(i) + " x Stick"
		self.add_child(n)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
