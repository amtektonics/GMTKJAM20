extends CanvasLayer




func _on_Play_pressed():
	LevelController.step_level()
	LevelController.load_level()

func _on_How_To_Play_pressed():
	get_node("/root/main/Level_0/Title").visible = false
	get_node("/root/main/Level_0/Menu/Main").visible = false
	get_node("/root/main/Level_0/Menu/HowTo").show()


func _on_Back_pressed():
	get_node("/root/main/Level_0/Title").show()
	get_node("/root/main/Level_0/Menu/Main").show()
	get_node("/root/main/Level_0/Menu/HowTo").visible = false
