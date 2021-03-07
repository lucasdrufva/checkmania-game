extends Spatial

var layout = [[null, null, null, null, null], [null, null, "C", null, null],[null, "T", null, null, null],[null, null, null, null, null],[null, null, null, null, null],]

var board = []

var gameId = ""
var currentTurn = 0
var player = 0


var piece = preload("res://scenes/Piece.tscn")
var moveIndicator = preload("res://scenes/moveIndicator.tscn")

var server = preload("res://scenes/Network.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(server)
	createBoard(layout)
	server.login("alice", "supersecret")
	

func createBoard(layout):
	for x in range(0, layout.size()):
		board.append([])
		for y in range(0, layout[x].size()):
			if layout[x][y] != null:
				board[x].append(piece.instance())
				
				board[x][y].transform.origin = Vector3(x*5, 0, y*5)
				board[x][y].id = str(x) + str(y)
				if layout[x][y] == "C":
					board[x][y].pieceType = 2
				elif layout[x][y] == "T":
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
	
	
	var legalMoves = getMoves(id)
	var moveIndicators = []
	
	for legalMove in legalMoves:
		moveIndicators.append(moveIndicator.instance())
		moveIndicators[moveIndicators.size()-1].transform.origin = Vector3(int(legalMove[0])*5, 0, int(legalMove[1])*5)
		moveIndicators[moveIndicators.size()-1].id = legalMove
		add_child(moveIndicators[moveIndicators.size()-1])
	
	#fake movement
	
#	yield(get_tree().create_timer(2), "timeout")
#	moveInd.queue_free()
#	var destination = id
#	destination[0] = String(int(destination[0])+1)
#	move(id, destination)

func destination_selected(destination):
	for x in range(0, board.size()):
		for piece in board[x]:
			if piece != null:
				if piece.selected:
					var move = {"source": piece.id, "destination":destination, "timestamp": str(OS.get_unix_time())}
					server.make_move(gameId, move)
					move(piece.id, destination)
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
	board[destinationRow][destinationCol] = board[sourceRow][sourceCol]
	board[sourceRow][sourceCol] = null
	board[destinationRow][destinationCol].transform.origin = Vector3(destinationRow*5, 0, destinationCol*5)
	board[destinationRow][destinationCol].id = str(destinationRow) + str(destinationCol)
	
	
	
	currentTurn = (currentTurn +1)%2
	if currentTurn:
		get_parent().get_node("Camera").direction = (get_parent().get_node("Camera").direction +1)%4
	print("current turn ", currentTurn)

func getMoves(source):
	var move1 = source
	var move2 = source
	if(get_parent().get_node("Camera").direction%2==0):
		move1[0] = String(int(move1[0])+1)
		move2[0] = String(int(move2[0])-1)
	else:
		move1[1] = String(int(move1[1])+1)
		move2[1] = String(int(move2[1])-1)
	
	return [move1, move2]



#server stuff
func _on_Server_joined_game(game):
	gameId = game
	print("joined Game!: ", gameId)

func _on_Server_get_move(game, newMove):
	move(newMove.source, newMove.destination)
