extends Sprite2D
class_name InteractionIndicator

@export_category("click")
@export var click_count: int = 1
@export var click_weight: int = 0

@export_category("dont_click")
@export var dont_click_count: int = 1
@export var dont_click_weight: int = 0

@export_category("mouse_motion")
@export var mouse_motion_count: int = 10
@export var mouse_motion_weight: int = 0


func build_interactions():
	var all: Array[Interactable.InteractionData]
	var total_weight: int = 0

	if click_weight != 0:
		total_weight += click_weight
		all.append(Interactable.InteractionData.init(
			Interactable.InteractionType.CLICK_COUNT,
			click_count, click_weight
			))

	if dont_click_weight != 0:
		total_weight += dont_click_weight
		all.append(Interactable.InteractionData.init(
			Interactable.InteractionType.DONT_CLICK,
			dont_click_count, dont_click_weight
			))

	if mouse_motion_weight != 0:
		total_weight += mouse_motion_weight
		all.append(Interactable.InteractionData.init(
			Interactable.InteractionType.MOUSE_MOTION,
			mouse_motion_count, mouse_motion_weight
			))

	return [ all, total_weight]

func get_data() -> Interactable.DataBundle:
	var bundle: Interactable.DataBundle = Interactable.DataBundle.new()
	bundle.location = self.position
	bundle.size = self.scale
	var tmp = build_interactions()
	bundle.interactions = tmp[0]
	bundle.interaction_weight = tmp[1]
	return bundle
