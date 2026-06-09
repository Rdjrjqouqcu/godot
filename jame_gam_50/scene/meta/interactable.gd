extends Node2D
class_name Interactable

enum InteractionType {
	CLICK_COUNT,
	DONT_CLICK,
	MOUSE_MOTION,
}

@export var difficulty:int = Main.Difficulty.EASY

var targets_to_clear = 0
signal failed
signal cleared

func _on_cleared():
	targets_to_clear -= 1
	if targets_to_clear == 0:
		get_parent().pass_puzzle()

func _on_failed():
	get_parent().fail_puzzle()

class InteractionData:
	static func init(itype: InteractionType, idifficulty: int, iweight: int) -> InteractionData:
		var n = InteractionData.new()
		n.type = itype
		n.difficulty = idifficulty
		n.weight = iweight
		return n
	var type: InteractionType
	var difficulty: int
	var weight: int
	func _to_string():
		return str("<",type,",",difficulty,",",weight,">")

class DataBundle:
	var location: Vector2i
	var size: Vector2i
	var interactions: Array[InteractionData]
	var interaction_weight: int
	func _to_string():
		return str("{", location, ",", size, ",", interactions, ",", interaction_weight, "}")

func _ready() -> void:
	cleared.connect(_on_cleared)
	failed.connect(_on_failed)

	var newNodes: Array
	for child in self.get_children():
		var data: DataBundle = child.get_data()
		child.queue_free()
		# Loggie.info(data)
		if randi_range(Main.Difficulty.EASY,Main.Difficulty.HARD + 1) <= difficulty:
			var weight = randi_range(0,data.interaction_weight)
			for interaction: InteractionData in data.interactions:
				weight -= interaction.weight
				if weight < 0:
					match interaction.type:
						InteractionType.CLICK_COUNT:
							newNodes.append(TargetClick.create_target(data.location, data.size, interaction.difficulty, cleared))
							targets_to_clear += 1
							break
						InteractionType.DONT_CLICK:
							newNodes.append(TargetNoClick.create_target(data.location, data.size,interaction.difficulty, failed))
							break
						InteractionType.MOUSE_MOTION:
							newNodes.append(TargetMove.create_target(data.location, data.size, interaction.difficulty, cleared))
							targets_to_clear += 1
							break

	if targets_to_clear == 0:
		Loggie.info("Puzzle without targets rolled, skipping")
		get_parent().queue_free()
		return

	for c in newNodes:
		add_child(c)
