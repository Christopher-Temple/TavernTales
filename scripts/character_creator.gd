extends Control
# Set variable to update later
var characterRace = "None"
var characterClass = "None"
var characterBackground = "None"
var characterName = "Nameless"
var characterTraits = []

var savePath = ""
var races =["Human", "Dwarf", "Halfling", "Elf", "Orc", "Gnome", "Aasimar", "Dragonborn", "Tiefling", "Lizardfolk", "Shadar-kai","Yuan-ti"]
var classes =["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Warlock", "Wizard", "Blood Hunter", "Treasure Hunter", "Artificer"]
var backgrounds=["Acolyte", "Anthropologist", "Artisan", "Athlete", "City Watch", "Criminal", "Entertainer", "Farmer", "Hermit", "Investigator", "Merchant", "Noble", "Pirate", "Ruined", "Sage" , "Smuggler", "Bounty Hunter"]
# Once all these variables are true, the user will be able to Save their character
var racePicked = false
var classPicked = false
var backgroundPicked = false
var namePicked = false
var genderPicked = false
var gender = ""

# bunch of variables to help total up stats based on choices
var characterStrRacial: int = 0
var characterDexRacial: int = 0
var characterConRacial: int = 0
var characterWisRacial: int = 0
var characterChaRacial: int = 0

var characterStrClass: int = 0
var characterDexClass: int = 0
var characterConClass: int = 0
var characterWisClass: int = 0
var characterChaClass: int = 0

var characterStrBackground: int = 0
var characterDexBackground: int = 0
var characterConBackground: int = 0
var characterWisBackground: int = 0
var characterChaBackground: int = 0

var characterTotalStr: int = 0
var characterTotalDex: int = 0
var characterTotalCon: int = 0
var characterTotalWis: int = 0
var characterTotalCha: int = 0

var characterRaceTrait = ""
var raceTraitInfo = ""
var characterClassTrait = ""
var classTraitInfo = ""
var characterBackgroundTrait = ""
var backgroundTraitInfo = ""
# Varaibles for equipment so they can be saved and loaded later
var armor = []
var weapon = []
var potion = []
var artifact = []
var questItem = []

@onready var raceList = $RaceList
@onready var classList = $ClassList
@onready var backgroundList = $BackgroundList
@onready var context = $ContextBox/Context
@onready var confirmTheme = load("res://themes/ConfirmPopup.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	_fill_list()
	#_update_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_ready_to_save()

func _fill_list():
	races.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
	for item in races:
		raceList.add_item(item)
	classes.sort_custom(func(a,b): return a.naturalnocasecmp_to(b) < 0)
	for item in classes:
		classList.add_item(item)
	backgrounds.sort_custom(func(a,b): return a.naturalnocasecmp_to(b) < 0)
	for item in backgrounds:
		backgroundList.add_item(item)

func _update_stats():
	characterTotalStr = 10+characterStrRacial+characterStrClass+characterStrBackground
	$BoxContainer/HBoxContainer/Race/HBoxContainer/Values/strValue.text = str(characterTotalStr)
	characterTotalDex = 10+characterDexRacial+characterDexClass+characterDexBackground
	$BoxContainer/HBoxContainer/Race/HBoxContainer/Values/dexValue.text = str(characterTotalDex)
	characterTotalCon = 10+characterConRacial+characterConClass+characterConBackground
	$BoxContainer/HBoxContainer/Race/HBoxContainer/Values/conValue.text = str(characterTotalCon)
	characterTotalWis = 10+characterWisRacial+characterWisClass+characterWisBackground
	$BoxContainer/HBoxContainer/Race/HBoxContainer/Values/wisValue.text = str(characterTotalWis)
	characterTotalCha = 10+characterChaRacial+characterChaClass+characterChaBackground
	$BoxContainer/HBoxContainer/Race/HBoxContainer/Values/chaValue.text = str(characterTotalCha)
	var listOfTraits = []
	
	listOfTraits.append(characterRaceTrait)
	if characterClassTrait != characterRaceTrait:
		listOfTraits.append(characterClassTrait + "[p]")
	if characterBackgroundTrait != characterRaceTrait and characterBackgroundTrait != characterClassTrait:
		listOfTraits.append(characterBackgroundTrait + "[p]")
	$BoxContainer/HBoxContainer/Traits/TraitsTextArea.text = str(listOfTraits).lstrip("[").rstrip("]").replace(",","[p]").replace("\"","")
	var traitDecriptions = [raceTraitInfo, classTraitInfo, backgroundTraitInfo]
	$BoxContainer/TraitDescriptions.text = str(traitDecriptions).lstrip("[").rstrip("]").replace(",","[p] [p]").replace("\"","")

func _ready_to_save():
	if namePicked == true and classPicked == true and racePicked == true and backgroundPicked == true and genderPicked == true:
		$Save.disabled = false
	else:
		$Save.disabled = true

func _on_return_pressed():
	$Click.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_pressed():
	$Click.play()
	_save_character()
	$fadescreen/CharacterSaved.popup_centered()
	$fadescreen/CharacterSaved.get_ok_button().focus_mode = Control.FOCUS_NONE
	$fadescreen.show()
	$fadescreen/CharacterSaved.show()

func _save_character():
	_set_starter_equipment()
	var characterFile = ConfigFile.new()
	characterFile.set_value("STATS","STR", characterTotalStr)
	characterFile.set_value("STATS","DEX", characterTotalDex)
	characterFile.set_value("STATS","CON", characterTotalCon)
	characterFile.set_value("STATS","WIS", characterTotalWis)
	characterFile.set_value("STATS","CHA", characterTotalCha)
	characterFile.set_value("INFO","NAME", characterName)
	characterFile.set_value("INFO","RACE", characterRace)
	characterFile.set_value("INFO","CLASS", characterClass)
	characterFile.set_value("INFO","BACKGROUND", characterBackground)
	characterFile.set_value("INFO","GENDER", gender)
	characterFile.set_value("TRAITS","RACE_TRAIT", characterRaceTrait)
	characterFile.set_value("TRAITS","CLASS_TRAIT", characterClassTrait)
	characterFile.set_value("TRAITS","BACKGROUND_TRAIT", characterBackgroundTrait)
	characterFile.set_value("INVENTORY","WEAPON", weapon)
	characterFile.set_value("INVENTORY","ARMOR", armor)
	characterFile.set_value("INVENTORY","POTIONS", potion)
	characterFile.set_value("INVENTORY","ARTIFACTS", artifact)
	characterFile.set_value("INVENTORY","QUESTITEMS", questItem)
	characterFile.save(savePath)

func _on_race_list_item_selected(index):
	$accept.play()
	racePicked = true
	var race = raceList.get_item_text(index)
	characterRace = race
	characterStrRacial = TavernDictonary.raceInformation[race+"Stats"]["STR"]
	characterDexRacial = TavernDictonary.raceInformation[race+"Stats"]["DEX"]
	characterConRacial = TavernDictonary.raceInformation[race+"Stats"]["CON"]
	characterWisRacial = TavernDictonary.raceInformation[race+"Stats"]["WIS"]
	characterChaRacial = TavernDictonary.raceInformation[race+"Stats"]["CHA"]
	if TavernDictonary.raceInformation[race+"Traits"] != "None":
		var traitInfo = TavernDictonary.raceInformation[race+"Traits"]
		raceTraitInfo = TavernDictonary.traitInformation[traitInfo]
		characterRaceTrait = TavernDictonary.raceInformation[race+"Traits"]
		
	else:
		characterRaceTrait = ""
		raceTraitInfo = ""
	_update_stats()

func _on_class_list_item_selected(index):
	$accept.play()
	classPicked = true
	var classChosen = classList.get_item_text(index)
	characterClass = classChosen
	characterStrClass = TavernDictonary.classInformation[classChosen+"Stats"]["STR"]
	characterDexClass = TavernDictonary.classInformation[classChosen+"Stats"]["DEX"]
	characterConClass = TavernDictonary.classInformation[classChosen+"Stats"]["CON"]
	characterWisClass = TavernDictonary.classInformation[classChosen+"Stats"]["WIS"]
	characterChaClass = TavernDictonary.classInformation[classChosen+"Stats"]["CHA"]
	if TavernDictonary.classInformation[classChosen+"Traits"] != "None":
		var traitInfo = TavernDictonary.classInformation[classChosen+"Traits"]
		classTraitInfo = TavernDictonary.traitInformation[traitInfo]
		characterClassTrait = TavernDictonary.classInformation[classChosen+"Traits"]
	else:
		characterClassTrait = ""
		classTraitInfo = ""
	_update_stats()

func _on_line_edit_text_changed(_new_text):
	if $LineEdit.text != "":
		namePicked = true
		characterName = $LineEdit.text
		savePath = "user://"+characterName+".cfg"
	elif $LineEdit.text == "":
		namePicked=false

func _on_background_list_item_selected(index):
	$accept.play()
	backgroundPicked = true
	var backgroundChosen = backgroundList.get_item_text(index)
	characterBackground = backgroundChosen
	characterStrBackground = TavernDictonary.backgroundInformation[backgroundChosen+"Stats"]["STR"]
	characterDexBackground = TavernDictonary.backgroundInformation[backgroundChosen+"Stats"]["DEX"]
	characterConBackground = TavernDictonary.backgroundInformation[backgroundChosen+"Stats"]["CON"]
	characterWisBackground = TavernDictonary.backgroundInformation[backgroundChosen+"Stats"]["WIS"]
	characterChaBackground = TavernDictonary.backgroundInformation[backgroundChosen+"Stats"]["CHA"]
	if TavernDictonary.backgroundInformation[backgroundChosen+"Traits"] != "None" :
		var traitInfo = TavernDictonary.backgroundInformation[backgroundChosen+"Traits"]
		backgroundTraitInfo = TavernDictonary.traitInformation[traitInfo]
		characterBackgroundTrait = TavernDictonary.backgroundInformation[backgroundChosen+"Traits"]
	else:
		characterBackgroundTrait = ""
		backgroundTraitInfo = ""
	_update_stats()

func _on_male_check_toggled(toggled_on):
	$accept.play()
	genderPicked = true
	GlobalVariables.gCharacterGender = "Male"
	gender = "Male"

func _on_female_check_pressed():
	$accept.play()
	genderPicked = true
	GlobalVariables.gCharacterGender = "Female"
	gender = "Female"

func _set_starter_equipment():
	if characterClass == "Barbarian":
		armor.append("Hide Armor")
		weapon.append("Iron Greatsword")
	elif characterClass == "Bard":
		armor.append("Chain Shirt")
		weapon.append("Iron Dagger")
	elif characterClass == "Cleric":
		armor.append("Chain Shirt")
		weapon.append("Iron Mace")
	elif characterClass == "Druid":
		armor.append("Hide Armor")
		weapon.append("Wooden Club")
	elif characterClass == "Fighter":
		armor.append("Chainmail")
		weapon.append("Iron Longsword")
	elif characterClass == "Monk":
		armor.append("Clothing")
		weapon.append("Quaterstaff")
	elif characterClass == "Paladin":
		armor.append("Chainmail")
		weapon.append("Iron Longsword")
	elif characterClass == "Ranger":
		armor.append("Leather Armor")
		weapon.append("Shortbow")
	elif characterClass == "Rogue":
		armor.append("Leather Armor")
		weapon.append("Iron Dagger")
	elif characterClass == "Warlock":
		armor.append("Padded Armor")
		weapon.append("Iron Rapier")
	elif characterClass == "Wizard":
		armor.append("Robe")
		weapon.append("Wooden Staff")
	elif characterClass == "Artificer":
		armor.append("Leather Armor")
		weapon.append("Light Crossbow")
	elif characterClass == "Treasure Hunter":
		armor.append("Padded Armor")
		weapon.append("Iron Scimitar")
	elif characterClass == "Blood Hunter":
		armor.append("Leather Armor")
		weapon.append("Iron Longsword")

func _on_character_saved_confirmed() -> void:
	$fadescreen.hide()
