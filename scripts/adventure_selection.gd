extends Control
# Path for save files. Empty for now.
var pathToSaves = ""

@onready var confirmTheme = load("res://themes/AcceptDialog.tres")

@onready var easyAdventures = load("res://scenes/easy_adventures.tscn")

func _ready():
	$LoadCharacter.root_subfolder = OS.get_user_data_dir()
	_clear_previous_information()
	_load_adventures()

	
func _load_adventures():
	await get_tree().create_timer(0.1).timeout
	var firstAdventures = easyAdventures.instantiate()
	get_tree().get_first_node_in_group("testgroup").add_child(firstAdventures)
	await get_tree().create_timer(0.5).timeout	
	firstAdventures._start_the_bounce()

func _on_character_select_label_pressed() -> void:
	$accept.play()
	$dimscreen.show()
	$LoadCharacter.visible = true

func _on_load_character_file_selected(path: String) -> void:
	# Set the path to save files, so we can use that path to read the file later
	pathToSaves = path
	$dimscreen.hide()
	_update_selected_character()
	GlobalVariables.characterChosen = true
	
func _update_selected_character():
	_clear_previous_information()
	var checkFile = _check_valid_save()
	if checkFile == false:
		$ErrorLoadingCharacter.popup_centered()
		$ErrorLoadingCharacter.get_ok_button().focus_mode = Control.FOCUS_NONE
		$dimscreen.show()
		$ErrorLoadingCharacter.show()
	else:
		var characterFile = ConfigFile.new()
		var err = characterFile.load(pathToSaves)
		if err != OK:
			err = characterFile.load_encrypted_pass(pathToSaves, "TavernTales")	
	
		# The get_var() will get the next variable from the file. So as long as they are loaded in the
		# same order they were saved, everything will load properly.
		var characterName = characterFile.get_value("INFO", "NAME")
		var characterRace = characterFile.get_value("INFO", "RACE")
		var characterClass = characterFile.get_value("INFO", "CLASS")
		var characterGender = characterFile.get_value("INFO","GENDER")
		var characterBackground = characterFile.get_value("INFO", "BACKGROUND")
		var characterTotalStr = characterFile.get_value("STATS", "STR")
		var characterTotalDex = characterFile.get_value("STATS", "DEX")
		var characterTotalCon = characterFile.get_value("STATS", "CON")
		var characterTotalWis = characterFile.get_value("STATS", "WIS")
		var characterTotalCha = characterFile.get_value("STATS", "CHA")
		var characterArmor = characterFile.get_value("INVENTORY", "ARMOR")
		var characterWeapon = characterFile.get_value("INVENTORY", "WEAPON")
		var characterPotion = characterFile.get_value("INVENTORY", "POTIONS")
		var characterArtifact = characterFile.get_value("INVENTORY", "ARTIFACTS")
		var characterQuestItem = characterFile.get_value("INVENTORY", "QUESTITEMS")
		var characterRaceTrait = characterFile.get_value("TRAITS","RACE_TRAIT")
		var characterClassTrait = characterFile.get_value("TRAITS","CLASS_TRAIT")
		var characterBackgroundTrait = characterFile.get_value("TRAITS", "BACKGROUND_TRAIT")
		
		# set all the global variables so the GUI can pull the information later
		GlobalVariables.gCharacterName = characterName
		GlobalVariables.gCharacterClass = characterClass
		GlobalVariables.gCharacterRace = characterRace
		GlobalVariables.gCharacterBackground = characterBackground
		GlobalVariables.gCharacterStr = characterTotalStr
		GlobalVariables.gCharacterDex = characterTotalDex
		GlobalVariables.gCharacterCon = characterTotalCon
		GlobalVariables.gCharacterWis = characterTotalWis
		GlobalVariables.gCharacterCha= characterTotalCha
		GlobalVariables.gCharacterHealth = characterTotalCon * 10
		GlobalVariables.gCharacterMana = characterTotalWis * 10
		GlobalVariables.gPlayerArmor = characterArmor
		GlobalVariables.gPlayerWeapon = characterWeapon
		GlobalVariables.gPlayerPotion = characterPotion
		GlobalVariables.gPlayerArtifact = characterArtifact
		GlobalVariables.gPlayerQuestItem = characterQuestItem
		GlobalVariables.gCharacterGender = characterGender
		if characterBackgroundTrait != "":
			GlobalVariables.gCharacterTraits.append(characterBackgroundTrait)
		if characterRaceTrait != "":
			GlobalVariables.gCharacterTraits.append(characterRaceTrait)
		if characterClassTrait != "":
			GlobalVariables.gCharacterTraits.append(characterClassTrait)
		
		# Set the preview character window with all the stats for the selected saved character
		$Container/LeftMain/HBoxContainer/StatValues/NameValue.text = characterName
		$Container/LeftMain/HBoxContainer/StatValues/RaceValue.text = characterRace
		$Container/LeftMain/HBoxContainer/StatValues/ClassValue.text = characterClass
		$Container/LeftMain/HBoxContainer/StatValues/BackgroundValue.text = characterBackground
		$Container/LeftMain/HBoxContainer/StatValues/StrValue.text = str(characterTotalStr)
		$Container/LeftMain/HBoxContainer/StatValues/DexValue.text = str(characterTotalDex)
		$Container/LeftMain/HBoxContainer/StatValues/ConValue.text = str(characterTotalCon)
		$Container/LeftMain/HBoxContainer/StatValues/WisValue.text = str(characterTotalWis)
		$Container/LeftMain/HBoxContainer/StatValues/ChaValue.text = str(characterTotalCha)
		$traitsValue.text = str(GlobalVariables.gCharacterTraits).replace("\"","").lstrip("[").rstrip("]")

func _clear_previous_information():
		GlobalVariables.gCharacterName = ""
		GlobalVariables.gCharacterClass = ""
		GlobalVariables.gCharacterRace = ""
		GlobalVariables.gCharacterBackground = ""
		GlobalVariables.gCharacterStr = 0
		GlobalVariables.gCharacterDex = 0
		GlobalVariables.gCharacterCon = 0
		GlobalVariables.gCharacterWis = 0
		GlobalVariables.gCharacterCha= 0
		GlobalVariables.gCharacterHealth =  0
		GlobalVariables.gCharacterMana = 0
		if GlobalVariables.gPlayerArmor.is_empty() == false:
			GlobalVariables.gPlayerArmor.clear()
		if GlobalVariables.gPlayerWeapon.is_empty() == false:
			GlobalVariables.gPlayerWeapon.clear()
		if GlobalVariables.gPlayerPotion.is_empty() == false:
			GlobalVariables.gPlayerPotion.clear()
		if GlobalVariables.gPlayerArtifact.is_empty() == false:
			GlobalVariables.gPlayerArtifact.clear()
		if GlobalVariables.gPlayerQuestItem.is_empty() == false:
			GlobalVariables.gPlayerQuestItem.clear()
		GlobalVariables.gCharacterGender = ""
		if GlobalVariables.gCharacterTraits.is_empty() == false:
			GlobalVariables.gCharacterTraits.clear()

	
func _on_return_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _check_valid_save():
	var characterFile = ConfigFile.new()
	var fileToCheck = characterFile.load(pathToSaves)
	if fileToCheck != OK:
		fileToCheck = characterFile.load_encrypted_pass(pathToSaves, "TavernTales")
	
	if characterFile.has_section_key("INFO", "NAME") == true:
		if characterFile.has_section_key("INFO", "RACE")== true:
			if characterFile.has_section_key("INFO", "CLASS")== true:
				if characterFile.has_section_key("INFO", "BACKGROUND")== true:
					if characterFile.has_section_key("STATS", "STR")== true:
						if characterFile.has_section_key("STATS", "DEX")== true:
							if characterFile.has_section_key("STATS", "CON")== true:
								if characterFile.has_section_key("STATS", "WIS")== true:
									if characterFile.has_section_key("STATS", "CHA")== true:
										if characterFile.has_section_key("INVENTORY", "ARMOR")== true:
											if characterFile.has_section_key("INVENTORY", "WEAPON")== true:
												if characterFile.has_section_key("INVENTORY", "POTIONS")== true:
													if characterFile.has_section_key("INVENTORY", "ARTIFACTS")== true:
														if characterFile.has_section_key("INVENTORY", "QUESTITEMS")== true:
															return true
														else: return false
													else: return false
												else: return false
											else: return false
										else: return false
									else: return false
								else: return false
							else: return false
						else: return false
					else: return false
				else: return false
			else: return false
		else: return false
	else: return false
	


func _on_error_loading_character_confirmed() -> void:
	$dimscreen.hide()


func _on_load_character_canceled() -> void:
	$dimscreen.hide()
