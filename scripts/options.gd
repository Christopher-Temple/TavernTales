extends Control


var settingsSavePath = "user://GameSettings.cfg"
var windowSizeTest = Vector2i(1080,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_current_window_mode()
	_set_encryption()
	_set_debug_mode()


func _on_return_pressed():
	$Accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_full_screen_toggled(_toggled_on):
	if $HBoxContainer/Windowed.button_pressed == true:
		$Accept.play()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	GlobalVariables.gWindowMode = 3

func _on_windowed_toggled(_toggled_on):
	if $HBoxContainer/FullScreen.button_pressed == true:
		$Accept.play()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GlobalVariables.gWindowMode = 0
	var window = get_window()
	window.size = Vector2i(1600,900)
	window.position = Vector2i(200,100)

func _set_current_window_mode():
	if GlobalVariables.gWindowMode == 0:
		$HBoxContainer/Windowed.button_pressed = true
		var window = get_window()
		window.size = Vector2i(1600,900)
		window.position = Vector2i(200,100)
	elif GlobalVariables.gWindowMode == 2:
		$HBoxContainer/Maximized.button_pressed = true
	elif GlobalVariables.gWindowMode == 3:
		$HBoxContainer/FullScreen.button_pressed = true
		
func _save_settings():
	
	var settingsConfig = ConfigFile.new()
	settingsConfig.set_value("VOLUME_OPTIONS","MASTER", float(GlobalVariables.gMasterVolume))
	settingsConfig.set_value("VOLUME_OPTIONS","SFX", float(GlobalVariables.gSfxVolume))
	settingsConfig.set_value("VOLUME_OPTIONS","MUSIC", float(GlobalVariables.gMusicVolume))
	settingsConfig.set_value("WINDOW_OPTIONS","WINDOW_MODE",GlobalVariables.gWindowMode)
	settingsConfig.set_value("SAVE_OPTIONS","ENCRYPTION",GlobalVariables.encryptedSave)
	settingsConfig.set_value("DEBUG_OPTIONS", "DEBUG", GlobalVariables.debugMode)
	settingsConfig.set_value("MUSIC_OPTIONS", "BACKGROUND", GlobalVariables.backgroundMusic)
	settingsConfig.save(settingsSavePath)

func _on_save_pressed():
	$Accept.play()
	_save_settings()
	$optionsSavedText.show()
	$optionsSavedText/Timer.start()

func _on_timer_timeout():
	$optionsSavedText.hide()

func _set_encryption():
	if GlobalVariables.encryptedSave == true:
		$HBoxContainer/EncryptData.button_pressed = true
	elif GlobalVariables.encryptedSave == false:
		$HBoxContainer/EncryptData.button_pressed = false
		
func _set_debug_mode():
	if GlobalVariables.debugMode == true:
		$HBoxContainer/Debug.button_pressed = true
	elif GlobalVariables.debugMode == false:
		$HBoxContainer/Debug.button_pressed = false


func _on_encrypt_data_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalVariables.encryptedSave = true
	if toggled_on == false:
		GlobalVariables.encryptedSave = false


func _on_debug_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalVariables.debugMode = true
	elif toggled_on == false:
		GlobalVariables.debugMode = false


func _on_music_chooser_item_selected(index: int) -> void:
	if index == 0:
		Music._play_main_music("wanderingKnight")
		GlobalVariables.backgroundMusic = "wanderingKnight"
	elif index == 1:
		Music._play_main_music("dancingNymph")
		GlobalVariables.backgroundMusic = "dancingNymph"
	elif index == 2:
		Music._play_main_music("brokenTankard")
		GlobalVariables.backgroundMusic = "brokenTankard"
	elif index == 3:
		Music._play_main_music("walkThroughTheSquare")
		GlobalVariables.backgroundMusic = "walkThroughTheSquare"
	elif index == 4:
		Music._play_main_music("fondMemories")
		GlobalVariables.backgroundMusic = "fondMemories"
