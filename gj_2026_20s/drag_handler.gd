extends HBoxContainer

enum ID {
	NONE = 0,
	LEFT = 1,
	MIDDLE = 2,
	RIGHT = 3,
}
var id = "WIP"

#var hover_id: ID = ID.NONE
#
#const click_mode_distance = 10
#const click_mode_timer_max = 0.5
#var click_mode_timer: float = 0.0
#func _process(delta: float) -> void:
	#if click_mode_timer > 0:
		#click_mode_timer -= delta
		#if click_mode_timer <= 0:
			#print("drag time")
			#DragProxy.inst().pick(id)
#
#var hovered: bool = false
#func _notification(what: int) -> void:
	#if what == NOTIFICATION_MOUSE_ENTER:
		#hovered = true
	#elif what == NOTIFICATION_MOUSE_EXIT:
		#hovered = false
#
#func _input(event: InputEvent) -> void:
	#if not hovered:
		#return
	#print(id+ " B " + str(event))
	#DragProxy.inst().hover(id)
	#if not DragProxy.inst().can_pick():
		#return
	#if event is InputEventMouseMotion:
		#if click_mode_timer > 0:
			#var dist = event.relative.length()
			#click_mode_timer -= click_mode_timer_max * dist / click_mode_distance
			#if click_mode_timer <= 0:
				#print("drag dist")
				#DragProxy.inst().pick(id)
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.is_pressed():
				#if DragProxy.inst().is_picked():
					#DragProxy.inst().drop()
				#else:
					#click_mode_timer = click_mode_timer_max
			#else:
				#if click_mode_timer > 0:
					#click_mode_timer = -1
					#print("click")
					#DragProxy.inst().pick(id)
				#elif DragProxy.inst().is_picked():
					#DragProxy.inst().drop()
