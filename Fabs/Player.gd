extends KinematicBody2D

export var move_speed =  8

export var gravity = 10

var velocity = Vector2()

var recording_started = false

var finished_recording = false

var move_left_buffer = []
var move_right_buffer = []
var jump_buffer = []

var max_jump_length = 50
var jump_speed_falloff = 0.00
var current_jump_index = 0
var is_jumping = false
var is_falling = false


func _ready():
	$AnimatedSprite.play("Idle");
	jump_speed_falloff = 1.0 / max_jump_length


var move_right_pressed = false
var move_left_pressed = false
var jump_pressed = false
var move_right_tick_count = 0
var move_left_tick_count =  0
var jump_tick_count = 0

var active_none = false

func _clean_playback():
	move_left_buffer.clear()
	move_right_buffer.clear()
	jump_buffer.clear()
	move_right_pressed = false
	move_left_pressed = false
	jump_pressed = false
	move_right_tick_count = 0
	move_left_tick_count = 0
	jump_tick_count = 0
	recording_started = false
	finished_recording = false
	
	current_jump_index = 0
	is_jumping = false
	is_falling = false
	jump_speed_falloff = 1.0 / max_jump_length
	
	tick_index = 0
	run_init = false
	temp_move_left = []
	temp_move_right = []
	temp_jump = []
	move_left_index_change = 0
	move_right_index_change = 0
	jump_index_change = 0
	move_left_index_totals = 0
	move_right_index_totals = 0
	jump_index_totals = 0
	read_next_move_left = true
	read_next_move_right = true
	read_next_jump = true
	
	move_left_state = false
	move_right_state = false
	jump_state = false
	
	active_none = false

	

func control(delta):
	if(Input.is_action_pressed("move_right")):
		recording_started = true
		if(!move_right_pressed):
			if(move_right_tick_count > 0):
				move_right_buffer.append(_build_input_packet(false, move_right_tick_count))
				move_right_tick_count = 0
			get_node("/root/main/InputDisplay").add_input("right")
			active_none = false
			move_right_pressed = true
		move_right_tick_count += 1
	else:
		if(recording_started):
			if(move_right_pressed):
				move_right_buffer.append(_build_input_packet(true, move_right_tick_count))
				move_right_tick_count = 0
				move_right_pressed = false
			move_right_tick_count += 1
	
	if(Input.is_action_pressed("move_left")):
		recording_started = true
		if(!move_left_pressed):
			if(move_left_tick_count > 0):
				move_left_buffer.append(_build_input_packet(false, move_left_tick_count))
				move_left_tick_count = 0
			get_node("/root/main/InputDisplay").add_input("left")
			active_none = false
			move_left_pressed = true
		move_left_tick_count += 1
	else:
		if(recording_started):
			if(move_left_pressed):
				move_left_buffer.append(_build_input_packet(true, move_left_tick_count))
				move_left_tick_count = 0
				move_left_pressed = false
			move_left_tick_count += 1
	
	if(Input.is_action_pressed("jump")):
		recording_started = true
		if(!jump_pressed):
			if(jump_tick_count > 0):
				jump_buffer.append(_build_input_packet(false, jump_tick_count))
				jump_tick_count = 0
			get_node("/root/main/InputDisplay").add_input("jump")
			active_none = false
			jump_pressed = true
		jump_tick_count += 1
	else:
		if(recording_started):
			if(jump_pressed):
				jump_buffer.append(_build_input_packet(true, jump_tick_count))
				jump_tick_count = 0
				
				if(move_right_pressed):
					get_node("/root/main/InputDisplay").add_input("right")
				elif(move_left_pressed):
					get_node("/root/main/InputDisplay").add_input("left")
				else:
					pass
				
				jump_pressed = false
			jump_tick_count += 1

	if(!jump_pressed && !move_left_pressed && !move_right_pressed && !active_none && recording_started):
		get_node("/root/main/InputDisplay").add_input("none")
		active_none = true
	
	if(Input.is_action_just_pressed("play") && recording_started):
		if(move_right_pressed):
			move_right_buffer.append(_build_input_packet(true, move_right_tick_count))
			move_right_tick_count = 0
		else:
			move_right_buffer.append(_build_input_packet(false, move_right_tick_count))
			move_right_tick_count = 0

		if(move_left_pressed):
			move_left_buffer.append(_build_input_packet(true, move_left_tick_count))
			move_left_tick_count = 0
		else:
			move_left_buffer.append(_build_input_packet(false, move_left_tick_count))
			move_left_tick_count = 0
		
		if(jump_pressed):
			jump_buffer.append(_build_input_packet(true, jump_tick_count))
			jump_tick_count = 0
		else:
			jump_buffer.append(_build_input_packet(false, jump_tick_count))
			jump_tick_count = 0
		
		get_node("/root/main/InputDisplay").pause()

		finished_recording = true

var tick_index = 0
var run_init = false
var temp_move_left = []
var temp_move_right = []
var temp_jump = []
var move_left_index_change = 0
var move_right_index_change = 0
var jump_index_change = 0
var move_left_index_totals = 0
var move_right_index_totals = 0
var jump_index_totals = 0
var read_next_move_left = true
var read_next_move_right = true
var read_next_jump = true

var move_left_state = false
var move_right_state = false
var jump_state = false

var kill_after_running = true
var finished_running = false
func run():
	if(!run_init):
		_init_temp_buffers()
		run_init = true
		tick_index = 0
		
	if(temp_move_left.size() == 0 || temp_move_right.size() == 0):
		if(read_next_move_right && read_next_move_left && read_next_jump):
			if(_on_floor()):
				_clean_playback()
				get_node("/root/main/InputDisplay").reset()
				finished_running = true
				return
	
	if(read_next_move_left && temp_move_left.size() > 0):
		var move_left = temp_move_left[0]
		move_left_state = move_left["value"]
		temp_move_left.pop_front()
		read_next_move_left = false
		move_left_index_change = move_left_index_totals + move_left["length"]
		move_left_index_totals += move_left["length"]
	
	if(read_next_move_right && temp_move_right.size() > 0):
		var move_right = temp_move_right[0]
		move_right_state = move_right["value"]
		temp_move_right.pop_front()
		read_next_move_right = false
		move_right_index_change = move_right_index_totals + move_right["length"]
		move_right_index_totals += move_right["length"]
	
	if(read_next_jump && temp_jump.size() > 0):
		var jump = temp_jump[0]
		jump_state = jump["value"]
		temp_jump.pop_front()
		read_next_jump = false
		jump_index_change = jump_index_totals + jump["length"]
		jump_index_totals += jump["length"]
	
	tick_index += 1
	if(tick_index >= move_right_index_change):
		read_next_move_right = true
	if(tick_index >= move_left_index_change):
		read_next_move_left = true
	if(tick_index >= jump_index_change):
		read_next_jump = true
	
	if(!read_next_move_left && move_left_state):
		velocity.x -= 1
	if(!read_next_move_right && move_right_state):
		velocity.x += 1
	
	#Jump code
	if(!read_next_jump && jump_state):
		if(_on_floor() && !is_jumping):
				is_jumping = true
		if(is_jumping):
				if(current_jump_index < max_jump_length):
					current_jump_index += 1
					velocity.y = -(1 - (current_jump_index * jump_speed_falloff))
				else:
					is_falling = true
		if(is_falling):
				if(_on_floor()):
					is_falling = false
					is_jumping = false
					current_jump_index = 0
				velocity.y += jump_speed_falloff
	else:
		if(is_jumping && !is_falling && current_jump_index > (max_jump_length / 4)):
			is_falling = true
			velocity.y = 0
			jump_speed_falloff = 1.0 / (current_jump_index)
		elif(is_jumping && !is_falling && current_jump_index <= (max_jump_length / 4)):
			current_jump_index += 1
			velocity.y = -(1 - (current_jump_index * jump_speed_falloff))
		
		if(is_falling):
			if(_on_floor()):
				is_falling = false
				is_jumping = false
				current_jump_index = 0
				jump_speed_falloff = 1.0 / max_jump_length
			velocity.y += jump_speed_falloff

func _init_temp_buffers():
		for i in range(move_right_buffer.size()):
			temp_move_right.append(move_right_buffer[i])
		for i in range(move_left_buffer.size()):
			temp_move_left.append(move_left_buffer[i])
		for i in range(jump_buffer.size()):
			temp_jump.append(jump_buffer[i])

func _physics_process(delta):
	var yt = velocity.y
	if(!is_jumping):
		yt = 1
	velocity = Vector2(0, yt)
	if(kill_after_running && finished_running):
		get_parent().queue_spawn_player()
	if(!finished_recording):
		control(delta)
	else:
		run()
	move_and_collide(Vector2(velocity.x * move_speed * 10 * delta, 0))
	move_and_collide(Vector2(0, velocity.y * gravity * 10 * delta))
	#var xt = velocity.x * move_speed * 10 * delta
	#var yt = velocity.y * gravity * 10 * delta
	#move_and_slide(Vector2(xt, yt))
	if(is_jumping):
		$AnimatedSprite.set_animation("Jump")
		$AnimatedSprite.set_frame(0)
		if(current_jump_index > (max_jump_length / 4) && $AnimatedSprite.get_frame() == 0):
			$AnimatedSprite.set_frame(1)
	elif(!is_jumping && $AnimatedSprite.get_animation() == "Jump"):
		$AnimatedSprite.play("Idle")
	if(velocity.x > 0):
		$AnimatedSprite.set_scale(Vector2(1, 1))
#		if($AnimatedSprite.is_flipped_h()):
#			$AnimatedSprite.set_flip_h(false)
		if($AnimatedSprite.get_animation() != "Walk_Right" && $AnimatedSprite.get_animation() != "Jump"):
			$AnimatedSprite.stop()
			$AnimatedSprite.play("Walk_Right");
	elif(velocity.x < 0):
		$AnimatedSprite.set_scale(Vector2(-1, 1))
#		if(!$AnimatedSprite.is_flipped_h()):
#			$AnimatedSprite.set_flip_h(true)
		if($AnimatedSprite.get_animation() != "Walk_Right" && $AnimatedSprite.get_animation() != "Jump"):
			$AnimatedSprite.stop()
			$AnimatedSprite.play("Walk_Right");
	else:
		if($AnimatedSprite.get_animation() != "Idle"):
			$AnimatedSprite.stop();
			$AnimatedSprite.play("Idle");
	
	if(Input.is_action_pressed("reset")):
		get_parent().queue_spawn_player()
	
	
func _build_input_packet(value:bool, length:int):
	return {"value": value, "length": length}

func _on_floor():
	if($FloorRay.is_colliding()):
		if($FloorRay.get_collider().name == "Tilemap"):
			return true
		else:
			return false
	else:
		return false
