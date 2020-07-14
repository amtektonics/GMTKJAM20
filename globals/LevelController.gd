extends Node

var level_index = 0
var current_level

func _ready():
	load_level()


func load_level():
	if(current_level != null):
		current_level.queue_free()
	var level = load("res://Fabs/Level_" + str(level_index) + ".tscn").instance()
	get_node("/root/main").add_child(level)
	current_level = level
	var inputDisplay = get_node("/root/main/InputDisplay")
	if(inputDisplay != null):
		inputDisplay.reset()

func step_level():
	level_index += 1

func set_level(value):
	level_index = value
