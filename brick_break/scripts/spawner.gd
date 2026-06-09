extends Node2D
class_name Spawner

var pos:Vector2i = Vector2i.ZERO
var root:Main

func _on_ball_enter(_body: Node2D) -> void:
	$Sprite.modulate.a = 0.5
func _on_ball_leave(_body: Node2D) -> void:
	if $Area2D.get_overlapping_bodies().size() == 0:
		$Sprite.modulate.a = 1.0

func overlaps_ball() -> bool:
	return $Area2D.has_overlapping_bodies()

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
	#Loggie.info("mouse on", pos)
	if not _is_valid_placement():
		return
	$Sprite.show()

func _on_mouse_off() -> void:
	#Loggie.info("mouse off", pos)
	$Sprite.hide()

func _on_mouse_click() -> void:
	#Loggie.info("spawn clicked", pos)
	if not _is_valid_placement():
		return
	if overlaps_ball():
		return
	root.add_block_at(Block.new_basic_block(pos, root), pos)
	$Sprite.hide()

func _ready() -> void:
	$Sprite.hide()
