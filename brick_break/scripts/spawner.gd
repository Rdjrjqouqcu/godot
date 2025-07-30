extends Node2D
class_name Spawner

var pos:Vector2i = Vector2i.ZERO
var root:Main

const SPAWNER = preload("res://scenes/spawner.tscn")
static func new_spawner(apos: Vector2i, aroot: Main) -> Spawner:
	var s = SPAWNER.instantiate()
	s.pos = apos
	s.position = Globals.map_position(apos)
	s.root = aroot
	return s

func _is_valid_placement() -> bool:
	return not root.has_block_at(pos)

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
	root.add_block_at(Block.new_basic_block(pos, root), pos)
	$Sprite.hide()

func _ready() -> void:
	$Sprite.hide()
