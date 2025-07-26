extends Control

var savePath = "user://GameSettings.save"
var settingsSavePath = "user://GameSettings.cfg"
var config = ConfigFile.new()

#@onready var packedCarousel = load("res://scenes/easy_adventures.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_check_settings()

# Quit Game
func _on_exit_pressed():
	get_tree().quit()
# Go to Options
func _on_button_pressed():
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/options.tscn")
# Go to main menu
func _on_start_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
# Go to Guide
func _on_guide_pressed():
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/guide.tscn")
# Check to see if you can load unencrypted settings. If you cannot, attempt to load encrypted settings
func _check_settings():
	var err = config.load(settingsSavePath)
	if err != OK:
		Music._play_main_music(GlobalVariables.backgroundMusic)
		return
	_load_settings()
	Volume._set_master()
	Volume._set_sfx()
	Volume._set_music()
	Music._play_main_music(GlobalVariables.backgroundMusic)
	if GlobalVariables.gWindowMode == 0 and GlobalVariables.gameLaunched == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var window = get_window()
		window.size = Vector2i(1600,900)
		window.position = Vector2i(200,100)
		GlobalVariables.gameLaunched = true
	elif GlobalVariables.gWindowMode == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	elif GlobalVariables.gWindowMode == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		return
	
func _load_settings():
	GlobalVariables.gMasterVolume = config.get_value("VOLUME_OPTIONS","MASTER")
	GlobalVariables.gSfxVolume = config.get_value("VOLUME_OPTIONS","SFX")
	GlobalVariables.gMusicVolume = config.get_value("VOLUME_OPTIONS","MUSIC")
	GlobalVariables.gWindowMode = config.get_value("WINDOW_OPTIONS","WINDOW_MODE")
	GlobalVariables.encryptedSave = config.get_value("SAVE_OPTIONS","ENCRYPTION")
	GlobalVariables.debugMode = config.get_value("DEBUG_OPTIONS","DEBUG")
	GlobalVariables.backgroundMusic = config.get_value("MUSIC_OPTIONS","BACKGROUND")


func _on_feedback_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/bug_report.tscn")


func _on_achievements_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/achievements.tscn")
