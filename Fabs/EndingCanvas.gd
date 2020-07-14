extends CanvasLayer



func _on_MainMenu_Button_pressed():
	LevelController.set_level(0)
	LevelController.load_level()
