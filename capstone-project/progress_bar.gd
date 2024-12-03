extends ProgressBar

# Reference to the character node (cat)
@export var character_node: NodePath

# Cached reference to the cat
var cat_node: Node

func _ready():
	# Get a reference to the cat node
	cat_node = get_node(character_node)
	if not cat_node:
		print("Error: Cat node not found!")

func _process(delta: float) -> void:
	# Check if the character node has the required methods
	if cat_node and cat_node.has_method("get_jump_time") and cat_node.has_method("get_jump_time_limit"):
		# Update the progress bar based on the jump time
		value = (cat_node.get_jump_time() / cat_node.get_jump_time_limit()) * max_value
