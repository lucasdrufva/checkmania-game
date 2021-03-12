extends Spatial

var utils = preload("res://scripts/Utils.gd")
onready var logic =  get_node("/root/Logic")
onready var server = get_node("/root/Network")

var layout = utils.notation_to_array("5ct/TC5/5ck/TC5/5ct/KC5/5ct/TC5")
#var layout = [[null, null, null, null, null], 
#			[null, null, "C", null, null],
#			[null, null, "T", null, null],
#			[null, null, null, null, null],
#			[null, null, null, null, null],]

var board = []

var gameId = ""

var player = 0


var piece = preload("res://scenes/Piece.tscn")
var moveIndicator = preload("res://scenes/MoveIndicator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(layout)
	add_child(server)
	createBoard(layout)
	#server.login("alice", "supersecret")
	

func createBoard(layout):
	for x in range(0, layout.size()):
		board.append([])
		for y in range(0, layout[x].size()):
			if layout[x][y] != null:
				board[x].append(piece.instance())
				
				board[x][y].transform.origin = Vector3(x*5, 0, y*5)
				board[x][y].id = str(x) + str(y)
				
				board[x][y].pieceType = logic.get_piece_type(layout[x][y])
				board[x][y].color = logic.get_color(layout[x][y])
				if layout[x][y].to_upper() == "C":
					board[x][y].pieceType = 2
				elif layout[x][y].to_upper() == "T":
					board[x][y].pieceType = 1
				
				add_child(board[x][y])
			else:
				board[x].append(null)

func piece_selected(id):
	print("piece selected ", id)
	
	#deselect other pieces
	for x in range(0, board.size()):
		for piece in board[x]:
			if piece != null:
				if piece.id != id:
					piece.selected = false
	
	
	print("time to get moves")
	var legalMoves = logic.get_moves(board, id)
	var moveIndicators = []
	
	print(legalMoves)
	
	for legalMove in legalMoves:
		moveIndicators.append(moveIndicator.instance())
		var indicatorPos = logic.indicator_pos(legalMove)
		var indicatorHeight = 0
		if(logic.destination_is_piece(board, legalMove)):
			indicatorHeight = 5
		moveIndicators[moveIndicators.size()-1].transform.origin = Vector3(int(indicatorPos[0])*5, indicatorHeight, int(indicatorPos[1])*5)
		moveIndicators[moveIndicators.size()-1].id = legalMove
		add_child(moveIndicators[moveIndicators.size()-1])
	

func destination_selected(destination):
	for x in range(0, board.size()):
		for piece in board[x]:
			if piece != null:
				if piece.selected:
					var move = {"source": piece.id, "destination":destination, "timestamp": str(OS.get_unix_time())}
					server.make_move(gameId, move)
					move(piece.id, destination)
					logic.make_move()
					break
	
	for child in self.get_children(): 
		if child.is_in_group("moveIndicator"): child.queue_free()
	

func move(source, destination):
	var sourceRow = int(source[0])
	var sourceCol = int(source[1])
	var destinationRow = int(destination[0])
	var destinationCol = int(destination[1])
	
	print(sourceRow, sourceCol, destinationRow, destinationCol)
	
	board[sourceRow][sourceCol].selected = false
	if(logic.destination_is_piece(board, destination)):
		board[destinationRow][destinationCol].kill()
	board[destinationRow][destinationCol] = null
	board[destinationRow][destinationCol] = board[sourceRow][sourceCol]
	board[sourceRow][sourceCol] = null
	board[destinationRow][destinationCol].transform.origin = Vector3(destinationRow*5, 0, destinationCol*5)
	board[destinationRow][destinationCol].id = str(destinationRow) + str(destinationCol)
	
	
	
	#currentTurn = (currentTurn +1)%2
	#if currentTurn:
	#	get_parent().get_node("Camera").direction = (get_parent().get_node("Camera").direction +1)%4
	print("current turn ", logic.currentTurn)

func get_moves(source):
	var move1 = source
	var move2 = source
	if(get_parent().get_node("Camera").direction%2==0):
		move1[0] = String(int(move1[0])+1)
		move2[0] = String(int(move2[0])-1)
	else:
		move1[1] = String(int(move1[1])+1)
		move2[1] = String(int(move2[1])-1)
	
	return [move1, move2]

func destination_is_piece(destination):
	var d0 = int(destination[0])
	var d1 = int(destination[1])
	if(d0 >= 0 && d0 <= board.size() - 1 && d1 >= 0 && d1 <= board[0].size() - 1):
		if(board[int(destination[0])][int(destination[1])] != null):
			return true
	return false

#server stuff
func _on_Server_joined_game(game):
	gameId = game
	print("joined Game!: ", gameId)

func _on_Server_get_move(game, newMove):
	move(newMove.source, newMove.destination)
