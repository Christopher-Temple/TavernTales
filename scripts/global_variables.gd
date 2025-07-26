extends Node


var gCharacterName = ""
var gCharacterClass = ""
var gCharacterRace = ""
var gCharacterBackground = ""
var gCharacterTraits = []
var gCharacterStr: int = 0
var gCharacterDex: int = 0
var gCharacterCon: int = 0
var gCharacterWis: int = 0
var gCharacterCha: int = 0
var gCharacterHealth: int = 0
var gCharacterMana: int = 0 
var gCharacterGender = ""
var gCharacterHasMagic = false

var gPlayerArmor : Array = []
var gPlayerWeapon :Array = []
var gPlayerPotion : Array = []
var gPlayerArtifact : Array = []
var gPlayerQuestItem : Array = []

var gEquippedWeapon = ""
var gEquippedArmor = ""
var gEquippedArtifact = ""
var gCurrentStoryID: int = 0

var gWindowMode = 0
var gMasterVolume = float (1)
var gSfxVolume = float (1)
var gMusicVolume = float (1)
var encryptedSave = false
var backgroundMusic = "wanderingKnight"

var gameLaunched = false
var gameMuted = false
var debugMode = false
var characterChosen = false

var act = 1
var adventureName : String

func _item_check(arg1):
	if gPlayerWeapon.has(arg1):
		return true
	elif gPlayerArmor.has(arg1):
		return true
	else:
		return false

# Act 1 variables
var acceptedMarcusHelp = false
