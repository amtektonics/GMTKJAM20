extends CanvasLayer

var idisplay_node_scene = preload("res://Fabs/input_display_node.tscn")

var displayed_inputs = []

var paused = false

func add_input(value):
	var input_display = idisplay_node_scene.instance()
	input_display.set_input(value)
	input_display.set_position(Vector2(1600 - 48, 48))
	$Panel.add_child(input_display)
	for i in range(displayed_inputs.size()):
		var pos = displayed_inputs[i].get_position()
		displayed_inputs[i].set_position(Vector2(pos.x - 64 , pos.y))
	
	displayed_inputs.push_front(input_display)


func _physics_process(delta):
	if(displayed_inputs.size() > 0 && !paused):
		displayed_inputs[0].step_hold_length()

func pause():
	paused = true


func reset():
	for i in range(displayed_inputs.size()):
		displayed_inputs[0].queue_free()
		displayed_inputs.pop_front()
	paused = false
