extends Node

class_name ServerApi

signal get_move(gameId, move)

var ws = null
var token = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ServerClient started")
	$HTTPRequest.connect("request_completed", self, "_on_login_request_completed")
	_connect("ws://localhost:8080/ws")
	login("bob", "supersecret")

func _connect(url):
	ws = WebSocketClient.new()
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	
	print("Connecting to " + url)
	ws.connect_to_url(url)

func _connection_established(protocol):
	print("Connection established with protocol: ", protocol)

func _connection_closed(m):
	print("Connection closed")
	print(m)

func _connection_error():
	print("Connection error")


func _process(_delta):
	if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
		ws.poll()
	if ws.get_peer(1).is_connected_to_host():
		if ws.get_peer(1).get_available_packet_count() > 0 :
			var test = ws.get_peer(1).get_packet()
			print('recieve %s' % test.get_string_from_ascii ())
			_parse_incomming_packet(test)

func _parse_incomming_packet(data):
	var json = JSON.parse(data.get_string_from_ascii())
	if(json.result):
		print("get move: ", json.result)
		emit_signal("get_move", "", json.result)

func login(username: String, password: String):
	var query = JSON.print({"name": username, "password": password})
	
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost:3000/api/auth/login", headers, false, HTTPClient.METHOD_POST, query)

#Login request complete
func _on_login_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	token = json.result.token
	print("JWT: ", token)
	var query = JSON.print({"action": "auth", "token": token})
	print(query)
	if ws.get_peer(1).is_connected_to_host():
		ws.get_peer(1).put_packet(query.to_utf8())


func make_move(gameId: String, move):
	var query = JSON.print({"action": "publish", "message": move})
	if ws.get_peer(1).is_connected_to_host():
		ws.get_peer(1).put_packet(query.to_utf8())




func _on_Timer_timeout():
	var move = {"source": "from", "destination":"to", "timestamp": str(OS.get_unix_time())}
	make_move("", move)
