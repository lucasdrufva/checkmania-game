extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Utils

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func notation_to_array(source):
	var board = []
	for block in source.split("/"):
		var layer = []
		for character in block:
			if(character.is_valid_integer()):
				for _i in range(0, int(character)):
					layer.append(null)
			else:
				layer.append(character)
		board.append(layer)
	return board

static func array_to_notation(source):
	var notation = ""
	for layerIndex in range(0, source.size()):
		var layer = source[layerIndex]
		var nullCount = 0
		for character in layer:
			if(character == null):
				nullCount += 1
			else:
				notation = notation + nullCount
				nullCount = 0
				notation = notation + character
		if(layer < source.size() - 1):
			notation = notation + "/"
	return notation

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
