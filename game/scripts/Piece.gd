extends Area

signal selected(id)

enum pieceTypes {king, tower, cube}
enum colors {red, blue}

export(pieceTypes) var pieceType
export(colors) var color
export(bool) var selected = false setget set_selected
export(String) var id

var kingBlue = preload("res://scenes/Pieces/King_Blue.tscn")
var towerBlue = preload("res://scenes/Pieces/Tower_Blue.tscn")
var cubeBlue = preload("res://scenes/Pieces/Cube_Blue.tscn")

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
		instance = kingBlue.instance()
		add_child(instance)
	elif pieceType == pieceTypes.tower:
		instance = towerBlue.instance()
		add_child(instance)
	else:
		instance = cubeBlue.instance()
		add_child(instance)
		
	print("spawned!", pieceType)
	print(str(OS.get_unix_time()))
	
	connect("selected", get_parent(), 'piece_selected')


func _input_event(object, event, click_position, click_normal, shape):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			print("input event")
			print(event)
			self.selected = !selected

