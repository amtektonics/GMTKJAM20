extends Sprite

var player_scene = preload("res://Fabs/Player.tscn")

var current_player

var timer: Timer

func _ready():

	queue_spawn_player()


func queue_spawn_player():
	timer = Timer.new()
	timer.connect("timeout", self, "_spawn_timeout")
	add_child(timer)
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.start()


func _spawn_player():
	if(current_player != null):
		current_player.queue_free()
	
	var player  = player_scene.instance()
	var pos = get_position()
	player.set_position(Vector2(0, 0))
	add_child(player)
	current_player = player
	if(timer != null):
		timer.queue_free()



func _spawn_timeout():
	_spawn_player()
