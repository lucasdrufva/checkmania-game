extends Area

signal selected(id)

enum pieceTypes {king, tower, cube}
enum colors {red, blue}

export(pieceTypes) var pieceType
export(colors) var color
export(bool) var selected = false setget set_selected
export(String) var id

var kingBlue = preload("res://scenes/Pieces/KingBlue.tscn")
var towerBlue = preload("res://scenes/Pieces/TowerBlue.tscn")
var cubeBlue = preload("res://scenes/Pieces/CubeBlue.tscn")

var kingRed = preload("res://scenes/Pieces/KingBlue.tscn")
var towerRed = preload("res://scenes/Pieces/CubeRed.tscn")
var cubeRed = preload("res://scenes/Pieces/CubeBlue.tscn")

var instance

func set_selected(value):
	selected = value
	instance.get_node("Cube/outline").visible = value
	if selected:
		emit_signal("selected", id)

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO add other pieces
	if pieceType == pieceTypes.king:
		if(color) == colors.blue:
			instance = kingBlue.instance()
		else:
			instance = kingRed.instance()
	elif pieceType == pieceTypes.tower:
		if(color) == colors.blue:
			instance = towerBlue.instance()
		else:
			instance = towerRed.instance()
	else:
		if(color) == colors.blue:
			instance = cubeBlue.instance()
		else:
			instance = cubeRed.instance()
	
	add_child(instance)
	
	print("spawned!", pieceType)
	print(str(OS.get_unix_time()))
	
	connect("selected", get_parent(), 'piece_selected')

func kill():
	queue_free()

func _input_event(object, event, click_position, click_normal, shape):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			print("input event")
			print(event)
			self.selected = !selected

