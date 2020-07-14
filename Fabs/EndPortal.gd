extends Area2D



func _physics_process(delta):
		var boddies = get_overlapping_bodies()
		if(boddies.size() > 0):
			for i in range(boddies.size()):
				if(boddies[i].name == "Player"):
					LevelController.step_level()
					LevelController.load_level()

