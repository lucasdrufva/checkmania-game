extends Camera

enum directions {north, east, south, west}

export(directions) var direction setget set_direction

var target = 0
var rot = 0
var cw = true
var wait = 0
var w = false

onready var logic =  get_node("/root/Logic")

func set_direction(value):
	direction = value
	target = 1.58*direction
	print("rotate camera! ", target)


# Called when the node enters the scene tree for the first time.
func _ready():
	logic.register_camera(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!(rot<target+0.02&&rot>target-0.02)):
		var tStart = Vector3(0,0,0)
		var deg
		if(cw):
			deg = 0.02
		else:
			deg = -0.01
		rot = fmod((rot + deg),6.27)
		global_translate (tStart)
		transform = transform.rotated(Vector3(0,1,0), deg)
		#global_translate (tStart)
		
		#if(rot >= 1.58):
			#cw = false
		#elif(rot <= 0):
			#cw = true
		#print(deg," ", rot, " ", target, " ", direction)
#	pass
