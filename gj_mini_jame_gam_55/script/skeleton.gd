extends Node2D

@export var grave: Grave

const WALK_SPEED: int = 20
const WALK_BUFF: float = 2
const DURATION_MAX: float = 10
const DURATION_BUFF: float = 1.5
const ATTACK_DMG: int = 10
const ATTACK_BUFF: float = 2.0
const COW_MODIFIER: float = 0.2

const WALK_BUFF_NECRO: float = 1.5
const DURATION_BUFF_NECRO: float = 1.5
const ATTACK_BUFF_NECRO: float = 1.5

var main: Main

var is_speed_buffed: bool = false
var is_attack_buffed: bool = false
var is_necromancer_buffed: bool = false

var duration: float = 0.0

var is_summoning: bool = false
var is_active: bool = false
var is_dying: bool = false
var is_done: bool = false

var is_attacking: bool = false
var attack_target: Barrier

var is_moving_cow: bool = false
var cow_target: Cow

var skull_start_pos: Vector2
var skull_top_pos: Vector2
var skeleton_start_pos: Vector2

func done() -> void:
	is_done = true
	$durability.visible = false
	$sprite.play("stand")

func die() -> void:
	if is_summoning or not is_active or is_dying or is_done:
		Loggie.error("inactive death", is_summoning, is_active, is_dying)
		return
	is_active = false
	is_attacking = false
	attack_target = null
	is_moving_cow = false
	cow_target = null
	$sprite.play("default")
	is_dying = true
	duration = 0
	$sprite.visible = false
	$durability.visible = false
	$skull/skull_smoke.visible = false
	for p: CPUParticles2D in $die_particles.get_children():
		p.emitting = true
	var die_tween = create_tween()
	die_tween.tween_property($skull, "position", Vector2($skull.position.x, skull_start_pos.y), 0.5)
	die_tween.tween_callback(_die_complete)
func _die_complete() -> void:
	is_dying = false
	$skull.position = skull_start_pos
	$sprite.flip_h = false
	$skull.flip_h = false
	position = skeleton_start_pos
	for p: CPUParticles2D in $skull_particles.get_children():
		p.emitting = true

func try_summon() -> void:
	if is_summoning or is_active or is_dying or is_done:
		return
	summon()
func summon() -> void:
	if is_summoning or is_active or is_dying or is_done:
		Loggie.error("active summon", is_summoning, is_active, is_dying)
		return
	is_summoning = true
	grave.summon_start()
	$skull/skull_smoke.visible = true
	var summon_tween = create_tween()
	summon_tween.tween_property($skull, "position", skull_top_pos, 1)
	summon_tween.tween_callback(_summon_complete)
func _summon_complete() -> void:
	is_summoning = false
	is_active = true
	$sprite.visible = true
	$durability.visible = true
	$skull/skull_smoke.visible = is_necromancer_buffed
	grave.summon_done()
	duration = DURATION_MAX * (DURATION_BUFF if main.has_durability_buff else 1.0)
	$durability.max_value = duration
	$durability.value = duration
	is_speed_buffed = main.has_speed_buff
	is_attack_buffed = main.has_attack_buff


func _ready() -> void:
	skull_start_pos = $skull.position
	skull_top_pos = $skull2.position
	skeleton_start_pos = position
	$skull.visible = true
	$skull/skull_smoke.visible = false
	$sprite.visible = false
	$skull2.queue_free()

func _process(delta: float) -> void:
	if is_done:
		return
	if is_active:
		var move_delta = delta * WALK_SPEED \
					* (WALK_BUFF if is_speed_buffed else 1.0) \
					* (WALK_BUFF_NECRO if is_necromancer_buffed else 1.0)
		if is_attacking:
			if not is_moving_cow:
				var damage = ATTACK_DMG * delta \
						* (ATTACK_BUFF if is_attack_buffed else 1.0) \
						* (ATTACK_BUFF_NECRO if is_necromancer_buffed else 1.0)
				if attack_target.take_damage(damage):
					is_attacking = false
					$sprite.play("default")
					attack_target = null
			else:
				position.x -= move_delta * COW_MODIFIER
				if cow_target.move_cow(move_delta * COW_MODIFIER):
					Loggie.info("TEST")
		else:
			position.x += move_delta
	if duration > 0:
		duration -= delta / (DURATION_BUFF_NECRO if is_necromancer_buffed else 1.0)
		$durability.value = duration
		if duration <= 0:
			die()

func set_necromancer_buff(enabled: bool) -> void:
	is_necromancer_buffed = enabled
	if is_active:
		$skull/skull_smoke.visible = enabled

func _on_attack_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Barrier:
		is_attacking = true
		$sprite.play("attack")
		attack_target = parent
	elif parent is Cow:
		is_attacking = true
		is_moving_cow = true
		$sprite.flip_h = true
		$skull.flip_h = true
		cow_target = parent
	else:
		Loggie.error("unknown attack")
