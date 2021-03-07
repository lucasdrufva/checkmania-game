extends Area

signal moveTo(id)

export(String) var id

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("moveTo", get_parent(), 'destination_selected')
	self.add_to_group("moveIndicator")


func _input_event(object, event, click_position, click_normal, shape):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			emit_signal("moveTo", id)
