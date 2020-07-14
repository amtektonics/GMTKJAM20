extends Sprite

var hold_length = 0



func set_input(value):
	if(value == "jump"):
		if(is_flipped_h()):
			set_flip_h(false)
		set_region_rect(Rect2(0, 0, 48, 48))
	if(value == "left"):
		if(!is_flipped_h()):
			set_flip_h(true)
		set_region_rect(Rect2(48, 0, 48, 48))
	if(value == "right"):
		if(is_flipped_h()):
			set_flip_h(false)
		set_region_rect(Rect2(48, 0, 48, 48))
		
	if(value == "none"):
		if(is_flipped_h()):
			set_flip_h(false)
		set_region_rect(Rect2(0, 48, 48, 48))

func step_hold_length():
	hold_length += 1
	$hold_length_label.text = str(hold_length)


func set_hold_length(value):
	hold_length = value
	$hold_length_label.text = str(hold_length)
