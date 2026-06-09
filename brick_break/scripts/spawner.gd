extends Node2D
class_name Spawner

var pos:Vector2i = Vector2i.ZERO
var root:Main

const SPAWNER = preload("res://scenes/spawner.tscn")
static func new_spawner(pos: Vector2i, root: Main) -> Spawner:
	var s = SPAWNER.instantiate()
	s.pos = pos
	s.position = Globals.map_position(pos)
	s.root = root
	return s

func _is_valid_placement() -> bool:
	return true

func _on_mouse_on() -> void:
	Loggie.info("mouse on", pos)
	if not _is_valid_placement():
		return
	$Sprite.show()

func _on_mouse_off() -> void:
	Loggie.info("mouse off", pos)
	$Sprite.hide()

func _on_mouse_click() -> void:
	Loggie.info("spawn clicked", pos)
	if not _is_valid_placement():
		return
	$Sprite.hide()

func _ready() -> void:
	$Sprite.hide()
