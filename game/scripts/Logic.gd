extends Node

var board = []

enum players {red, blue}

var cameraNode = null

var currentTurn = 0 setget next_turn

var currentPlayer = players.red

export var playerColor = players.red

func next_turn(new_value):
	currentTurn = new_value
	currentPlayer = currentTurn%2
	print("next turn", currentPlayer, currentTurn)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_moves(newBoard, source):
	print("get moves")
	board = newBoard
	var move1 = source
	var move2 = source
	#Tower
	if(board[int(source[0])][int(source[1])].pieceType == 1):
		if(cameraNode.direction%2==0):
			var frontBack = -1
			if(cameraNode.direction==2):
				frontBack = 1				
			move1[0] = String(int(move1[0])+1)
			move1[1] = String(int(move1[1])+frontBack)
			move2[0] = String(int(move2[0])-1)
			move2[1] = String(int(move2[1])+frontBack)
		else:
			var frontBack = -1
			if(cameraNode.direction==3):
				frontBack = 1		
			move1[1] = String(int(move1[1])+1)
			move1[0] = String(int(move1[0])+frontBack)
			move2[1] = String(int(move2[1])-1)
			move2[0] = String(int(move2[0])+frontBack)

	else:
		if(cameraNode.direction%2==0):
			move1[0] = String(int(move1[0])+1)
			move2[0] = String(int(move2[0])-1)
		else:
			move1[1] = String(int(move1[1])+1)
			move2[1] = String(int(move2[1])-1)
	
	print("return:" , [move1, move2])
	return [move1, move2]

func destination_is_piece(newBoard, destination):
	board = newBoard
	var d0 = int(destination[0])
	var d1 = int(destination[1])
	if(d0 >= 0 && d0 <= board.size() - 1 && d1 >= 0 && d1 <= board[0].size() - 1):
		if(board[int(destination[0])][int(destination[1])] != null):
			return true
	return false

func indicator_pos(pos):
	var position = [pos[0], pos[1]]
	if(cameraNode.direction == 0):
		position[1] = 12
	elif(cameraNode.direction == 1):
		position[0] = 12
	elif(cameraNode.direction == 2):
		position[1] = -5
	elif(cameraNode.direction == 3):
		position[0] = -5
	
	return [position[0], position[1]]

func make_move():
	self.currentTurn += 1
	cameraNode.direction = int(floor((currentTurn%8)/2))

func register_camera(camera):
	cameraNode = camera

func get_piece_type(notation):
	if (notation.to_upper() == "C"):
		return 2
	elif (notation.to_upper() == "T"):
		return 1
	return 0

func get_color(notation):
	if(notation == "c"||notation == "t"||notation == "k"):
		return 1
	return 0

func isYourTurn():
	print("current player ", currentPlayer)
	return playerColor == currentPlayer

func isColorsTurn(newBoard, id):
	board = newBoard
	if(board[int(id[0])][int(id[1])].color == currentPlayer):
		return true
	return false
