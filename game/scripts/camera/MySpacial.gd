extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rot = 0
var cw = true
var wait = 0
var w = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(w):
		wait += 1
		if(wait == 1):
			wait = 0
			w = false
	else:
		var tStart = Vector3(0,0,0)
		var deg
		if(cw):
			deg = 0.02
		else:
			deg = -0.02
		rot += deg
		global_translate (-tStart)
		transform = transform.rotated(Vector3(0,1,0), deg)
		global_translate (tStart)
		
		if(rot >= 1.58):
			w = true
			cw = false
		elif(rot <= 0):
			w = true
			cw = true
		print(deg)
#	pass
