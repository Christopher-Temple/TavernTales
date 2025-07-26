extends OptionButton


func _on_item_selected(index: int) -> void:
	if index == 0:
		if AudioServer.is_bus_mute(0) == true:
			AudioServer.set_bus_mute(0,false)
		else:
			AudioServer.set_bus_mute(0,true)
	if index == 1:
		if DisplayServer.window_get_mode() == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var window = get_window()
			window.size = Vector2i(1600,900)
			window.position = Vector2i(200,100)
	if index == 2:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if index == 3:
		get_tree().quit()
