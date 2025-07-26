extends Control

@onready var story = $GUI/AdventureText
@onready var GUI = $GUI
@onready var optionOne = GUI.option_one
@onready var optionTwo = GUI.option_two
@onready var optionThree = GUI.option_three
@onready var optionFour = GUI.option_four
@onready var optionFive = GUI.option_five
@onready var optionSix = GUI.option_six
@onready var arigashBattle = load("res://scenes/BattleMaps/a_1_pond_fight.tscn")
@onready var boarbattle = load("res://scenes/BattleMaps/a_1_boar_fight.tscn")
@onready var goblinAmbush = load("res://scenes/BattleMaps/forest_fight.tscn")
@onready var achPopup = load("res://scenes/achievement_popup.tscn")

var characterPortrait = GlobalVariables.gCharacterRace + GlobalVariables.gCharacterGender
var playerName = GlobalVariables.gCharacterName
var playerRace = GlobalVariables.gCharacterRace
var playerClass = GlobalVariables.gCharacterClass
var playerBackground = GlobalVariables.gCharacterBackground

var askedAboutChildren = false
var askedAboutGoblins = false
var askedAboutReward = false
var dayCounter = int (0)
var talkedToCompanion = false
var investigatedVillage = false
var talkedToMarcus = false
var playerGold = 0
var visitedPond = false
var pondStory = false
var pondTradable = false
var pondSus = false

var flavorText = "[i][color=web_maroon]"
var flavorTextStop = "[/color][/i]"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.gCurrentStoryID = int(0)
	_reset_background()


# receive the file name with the scene argument. check the tree for the first node in group CurrentBackground
# which there should hopefully only be 1 at any given time. Remove that node then create a new background Sprite2d
# set the texture to our new Bg image and set the nodes name to the filename that was passed with the scene argument
# add that new node as a child to the BackgroundSpawn node, which is the only node in Background group
func _update_background_scene(scene,alpha):
	var new_background = Sprite2D.new()
	new_background.texture = load("res://assets/images/adventureOne/" + scene + ".png")
	new_background.name = scene
	new_background.modulate = Color(1,1,1,alpha)
	new_background.add_to_group("CurrentBackground")
	get_tree().get_first_node_in_group("Background").add_child(new_background)

func _reset_background():
	get_tree().get_first_node_in_group("CurrentBackground").queue_free()
	var new_background = Sprite2D.new()
	new_background.texture = load("res://assets/images/bgSizeTemplate.png")
	new_background.name = "defaultBackground"
	new_background.add_to_group("CurrentBackground")
	get_tree().get_first_node_in_group("Background").add_child(new_background)
	

func _update_left_spawn(image):
	var newImage = Sprite2D.new()
	newImage.texture = load("res://assets/images/adventureOne/" + image + ".png")
	newImage.name = image
	newImage.add_to_group("LeftImage")
	get_tree().get_first_node_in_group("LeftImageSpawn").add_child(newImage)

func _update_middle_spawn(image):
	var newImage = Sprite2D.new()
	if image == characterPortrait:
		newImage.texture = load("res://assets/images/"+image+".png")
	else:
		newImage.texture = load("res://assets/images/adventureOne/" + image + ".png")
	newImage.name = image
	newImage.add_to_group("MiddleImage")
	get_tree().get_first_node_in_group("MiddleImageSpawn").add_child(newImage)
	
func _update_right_spawn(image):
	var newImage = Sprite2D.new()
	newImage.texture = load("res://assets/images/adventureOne/" + image + ".png")
	newImage.name = image
	newImage.add_to_group("RightImage")
	get_tree().get_first_node_in_group("RightImageSpawn").add_child(newImage)
	
func _clear_left_image():
	var leftImages = get_tree().get_nodes_in_group("LeftImage")
	for i in leftImages:
		i.queue_free()

func _clear_middle_image():
	var middleImages = get_tree().get_nodes_in_group("MiddleImage")
	for i in middleImages:
		i.queue_free()

func _clear_right_image():
	var rightImages = get_tree().get_nodes_in_group("RightImage")
	for i in rightImages:
		i.queue_free()

# In order to update the story, we will use story.text to change the text in the main box
# Then we will set the button text as well as the button tooltip text
# The tooltip text will be the unique ID that is passed back via _update_story(storyID)
# Which then takes that tooltip ID and matches it within the match statement to
# Print out the next bit of story and update the buttons
func _act_one(storyID):
	match storyID:
		0:
			# Beginning
			GlobalVariables.gCurrentStoryID = int(0)
			_update_background_scene("tavernBackground",1)
			story.text = flavorText+"You approach a table occupied by a lively " + playerRace + ". They are recounting a past adventure in which they rescued some children from a rogue band of goblins."
			optionOne.text = "Listen"
			optionOne.tooltip_text = "1"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		1:
			# 0
			# _update_middle_spawn(characterPortrait)
			_reset_background()
			_update_background_scene("tavernBackground",.3)
			GlobalVariables.gCurrentStoryID = int(1)
			story.text = playerName+" : \" It was late in the day as Bargin and I approached this little village. With his leg being all busted up, we were traveling slow and starting to get worried we might not reach a village before nightfall. As we got closer though, we could tell something wasn't quite right, every one seemed to be running around from one house to the next, and there was lots of shouting going on. Bargin sat down against a tree trunk near the edge of the village and I ran down to see what was going on.\""
			optionOne.text = "Continue"
			optionOne.tooltip_text = "2"
			GUI._enable_buttons(1,0,0,0,0,0)
		2:
			# 1
			GlobalVariables.gCurrentStoryID = int(2)
			_reset_background()
			_clear_middle_image()
			_update_background_scene("adventureonevillage",.3)
			story.text = flavorText+"You run towards the village as the voices get louder and louder. The closer you get, the more you start putting together the gist of what has the village abuzz with commotion. Goblins have clearly raided recently. One of the villagers notices you approaching and breaks off from the crowd to greet you."+flavorTextStop+"[p][p]Avelina : \"Hello stranger, I apologize for the lack of proper introductions, but we have a bit of a problem right now. The inn is on the far side of the village if you are wanting a bed for the night. Now if you'll pardon me...\"[p]"+flavorText+"And with that, the young lady hastily turns around and rushes back towards the gathering of people."
			optionOne.text = "Follow Her"
			optionOne.tooltip_text = "3"
			optionTwo.text = "Track Goblins"
			optionTwo.tooltip_text = "12"
			if GlobalVariables.gCharacterBackground == "Investigator" or GlobalVariables.gCharacterBackground == "City Watch":
				optionSix.text = GlobalVariables.gCharacterBackground
				optionSix.tooltip_text ="11"
				GUI._enable_buttons(0,0,0,0,0,1)
			for i in GlobalVariables.gCharacterTraits:
				if i == "Tactical Mind" or i == "Survival" or i== "Treasure Hunter":
					optionFive.text = i
					optionFive.tooltip_text = "11"
					GUI._enable_buttons(0,0,0,0,1,0)
			if playerRace == "Orc" or playerRace == "Dwarf":
				optionFour.text = playerRace
				optionFour.tooltip_text = "13"
				GUI._enable_buttons(0,0,0,1,0,0)
			GUI._enable_buttons(1,1,0,0,0,0)
		3:
			# 2
			GlobalVariables.gCurrentStoryID = int(3)
			_reset_background()
			_clear_middle_image()
			_update_background_scene("villageCenter",1)
			story.text = flavorText+"You follow the lady towards the village center where a large bonfire has been lit. You can see many of the men have gathered some crude weapons, mostly farm tools that could double as weapons. You stop close to the village center, far enough to not draw more than a curious glance, but close enough to hear the discussion."+flavorTextStop+"[p]Marcus : \"We have to leave immediently, every second we waste, the goblins get closer to their holes and the risk to our children grows.\" "+flavorText+"[p]There seems to be some in favor of chasing after the goblins, and some against heading out with the sun starting to set."
			optionOne.text = "Talk to Marcus"
			optionOne.tooltip_text = "4"
			if GlobalVariables.gCharacterTraits.has("Criminal"):
				optionTwo.text = "Criminal"
				optionTwo.tooltip_text = 25
				GUI._enable_buttons(0,1,0,0,0,0,0)
			GUI._enable_buttons(1,0,0,0,0,0)
		4:
			# 3
			GlobalVariables.gCurrentStoryID = int(4)
			_reset_background()
			_update_background_scene("villageCenter",0.30)
			talkedToMarcus = true
			story.text = flavorText+"You walk towards the man speaking and a few others draw closer to him as well. You recognize one as the woman who greeted you when you entered the village."+flavorTextStop+"[p]Marcus : \"Greetings stranger, my name is Marcus. I wish we could have met under different circumstances, but welcome none the less. Is there anything I can help you with?\""
			optionOne.text = "Goblins"
			optionOne.tooltip_text = "5"
			optionTwo.text = "Children"
			optionTwo.tooltip_text = "14"
			GUI._enable_buttons(1,1,0,0,0,0)
			
		5:
			# 4
			GlobalVariables.gCurrentStoryID = int(5)
			askedAboutGoblins = true
			story.text = playerName+" : \"I heard mention of goblin as I approached the village. What exactly has happened?\" [p]" +flavorText+ "Marcus glances quickly towards the bonfire where most the village is gathered, his face taking on a look of disgust."+flavorTextStop+"[p]Marcus : \"Goblins have been a bother for as long as I can remember. It's a small tribe, broke off from one of the larger tribes up north. They tend to stay away from the villages, but they have no qualms attacking anyone who strays too far or unprotected carvavans. Today though...today they were brave enough to raid the village.\""
			optionOne.text = "Raid"
			optionOne.tooltip_text = "6"
			optionTwo.text = "Children"
			optionTwo.tooltip_text = "14"
			if GlobalVariables.gCharacterBackground == "Bounty Hunter":
				optionSix.text = "Bounty Hunter"
				optionSix.tooltip_text = "15"
				GUI._enable_buttons(0,0,0,0,0,1)
			GUI._enable_buttons(1,1,0,0,0,0)
		6:
			# 5
			GlobalVariables.gCurrentStoryID = int(6)
			story.text = playerName+" : \"Is everyone ok? \"[p]Marcus : \"They took a couple of the young ones, and old Billy tried to stop them, got himself gutted. Old fool was nearing 80, should have let us younger men handle the goblins. Never was one to back down though, brave old fool. Some of us want to take off after the goblins and try to rescue the children, but most say it's too dangerous to chase after them with night approaching. Others say chasing goblins to their caves is dangerous no matter where the sun sits in the sky.\"" 
			optionOne.text = "Offer Help"
			optionOne.tooltip_text = "7"
			optionTwo.text = "Payment"
			optionTwo.tooltip_text = "15"
			if askedAboutChildren == false:
				optionThree.text = "Children"
				optionThree.tooltip_text = "14"
				GUI._enable_buttons(0,0,1,0,0,0)
			GUI._enable_buttons(1,1,0,0,0,0)
		7:
			# 6
			GlobalVariables.gCurrentStoryID = int(7)
			story.text = playerName+" : \"My partner Bargin and I have a bit of experience fighting goblins. I'll track down the goblins and try to rescue the children if you can look after Bargin till I'm back.\"[p]"+flavorText+"You nod your head towards the edge of the village where you left Bargin.[p]Marcus grows visibly excited as you speak."
			optionOne.text = "Continue"
			optionOne.tooltip_text = "8"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		8:
			# 7
			GlobalVariables.gCurrentStoryID = int (8)
			story.text = "Marcus : I'll come with you. There are a few others who wanted to track the goblins down, but they're still young and none of them as skilled at tracking as I am. With just the two of us, we can move swiftly and quietly."
			optionOne.text = "Accept Help"
			optionOne.tooltip_text = "9"
			optionTwo.text = "Decline Help"
			optionTwo.tooltip_text = "10"
			GUI._enable_buttons(1,1,0,0,0,0)
				
		9:	# Accepted help from Marcus
			# 8
			GlobalVariables.gCurrentStoryID = int(9)
			story.text = playerName+" : \"With Bargin out of commission, an extra blade watching my back would be welcome. Do you know which way the goblins fled from the village?\"[p]Marcus : \"They fled to the east, along the edge of the river."
			GlobalVariables.acceptedMarcusHelp = true
			if Achievements.gkAcceptMarcusHelp != true:
				Achievements._single_save("GOBLIN_KING", "Accept_Help_From_Marcus", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("Accepted Help From Marcus")
			optionOne.text = "Follow Goblins"
			optionOne.tooltip_text = "12"
			if investigatedVillage == false:
				if playerBackground == "Investigator" or playerBackground == "City Watch":
					optionSix.text = playerBackground
					optionSix.tooltip_text ="11"
					GUI._enable_buttons(0,0,0,0,0,1)
				for i in GlobalVariables.gCharacterTraits:
					if i == "Tactical Mind" or i == "Survival":
						optionFive.text = i
						optionFive.tooltip_text = "11"
						GUI._enable_buttons(0,0,0,0,1,0)
			GUI._enable_buttons(1,0,0,0,0,0)
			
		10: # Decline Help from Marcus
			GlobalVariables.gCurrentStoryID = int(10)
			story.text = playerName+" : \"While I appreciate the offer, I'll move faster alone and have a better chance of catching up to the goblins before they reach their caves. You should stay here in case any return and to help lead the others in this time of distress.\""
			if Achievements.gkDeclineMarcusHelp != true:
				Achievements._single_save("GOBLIN_KING", "Decline_Help_From_Marcus", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("Declined Help From Marcus")
			optionOne.text = "Follow Goblins"
			optionOne.tooltip_text = "12"
			if investigatedVillage == false:
				if playerBackground == "Investigator" or playerBackground == "City Watch":
					optionSix.text = playerBackground
					optionSix.tooltip_text ="11"
					GUI._enable_buttons(0,0,0,0,0,1)
				for i in GlobalVariables.gCharacterTraits:
					if i == "Tactical Mind" or i == "Survival":
						optionFive.text = i
						optionFive.tooltip_text = "11"
						GUI._enable_buttons(0,0,0,0,1,0)
			GUI._enable_buttons(1,0,0,0,0,0)
		11: # Investigate around town
			# 2
			GlobalVariables.gCurrentStoryID = int (11)
			_clear_left_image()
			_clear_middle_image()
			_clear_right_image()
			investigatedVillage = true
			if playerBackground != "Treasure Hunter":
				story.text = flavorText+"You move around the village carefully taking note of the various signs of battle. You notice several places where bodies were clearly drug through the dirt and mud towards the center of the village. A few old rusted looking weapons lay scattered about, mostly dagger-sized weapons, though a few shortswords as visible as well. Clearly a few deaths occured here, and bodies were drug to the fire roaring in the center of the village."
			else:
				story.text = flavorText+"You move around the village carefully, taking in details of the short battle that happened in the village. At the base of a tree, you notice a severed goblin hand, still holding it's weapon. The blade's edge seems sharp at a glance, sharper than you would expect for a goblin weapon."
				optionFive.text = "Grab Weapon"
				optionFive.tooltip_text = "22"
				GUI._enable_buttons(0,0,0,0,1,0)
			if talkedToMarcus == false:
				optionTwo.text = "Town Center"
				optionTwo.tooltip_text = "3"
				GUI._enable_buttons(0,1,0,0,0,0)
			optionOne.text = "Follow goblins"
			optionOne.tooltip_text = "12"
			GUI._enable_buttons(1,0,0,0,0,0)

		12: # Follow Goblins
			GlobalVariables.gCurrentStoryID = int (12)
			_clear_middle_image()
			_clear_left_image()
			_clear_right_image()
			_reset_background()
			_update_background_scene("leaveVillage", 1)
			_update_middle_spawn(characterPortrait)
			if GlobalVariables.acceptedMarcusHelp == true:
				_update_left_spawn("marcus")
				story.text = flavorText+"You and Marcus gather at the edge of the village. Signs of the goblins passing are clearly visible, it doesn't seem they were worried about being followed"+flavorTextStop+"[p]"+GlobalVariables.gCharacterName+" : \"It doesn't look like we will have a hard time tracking the main group, but be on the look out for any tracks veering off from the group."
			else:
				story.text = flavorText+"You arrive at the edge of the village. Signs of the goblins passing are clearly visible, it doesn't seem they were worried about hiding their tracks."
			GlobalVariables.act = 2
			optionOne.text = "Track Goblins"
			optionOne.tooltip_text = "0"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		13: # Orc Race
			# 2
			GlobalVariables.gCurrentStoryID = int (13)
			investigatedVillage = true
			story.text = flavorText+"Being a "+playerRace+" , you've seen this type of raid plenty of times. Tale-tell signs of goblin activity are all over this small village, and the stench of goblin corpses is something you never forget."
			optionOne.text = "Town Center"
			optionOne.tooltip_text = "3"
			GUI._enable_buttons(1,0,0,0,0,0)
		14:
			# 4
			GlobalVariables.gCurrentStoryID = int (14)
			askedAboutChildren = true
			story.text = flavorText+"Avelina steps a little closer, hands clasped in front of her."+flavorTextStop+"[p]Avelina : \"They took two of the young ones, little Abby the Seamstress' daughter and Thamas, the Innkeeper' s son. Neither even 10 years old yet. Please...please help us rescue them.\"[p]"+flavorText+"You can clearly see the tears forming in Avelina' s eyes as she begs for your help."
			optionOne.text = "Offer Help"
			optionOne.tooltip_text = "7"
			optionTwo.text = "Payment"
			optionTwo.tooltip_text = "15"
			GUI._enable_buttons(1,1,0,0,0,0)
			if askedAboutGoblins == false:
				optionThree.text = "Raid"
				optionThree.tooltip_text = "6"
				GUI._enable_buttons(0,0,1,0,0,0)
			
		15:
			#7
			GlobalVariables.gCurrentStoryID = int (15)
			story.text = playerName+" \"Before I agree to help, there is something I need to ask of you.\""
			optionOne.text = "Care for Bargin"
			optionOne.tooltip_text = "16"
			GUI._enable_buttons(1,0,0,0,0,0)
			if playerBackground == "Merchant" or playerBackground == "Bounty Hunter" or playerBackground == "Ruined":
				optionTwo.text = playerBackground
				optionTwo.tooltip_text = "17"
				GUI._enable_buttons(0,1,0,0,0,0)
			if playerRace == "Shadar-kai" or playerRace == "Gnome" or playerRace == "Dwarf":
				optionThree.text = playerRace
				optionThree.tooltip_text = "27"
				GUI._enable_buttons(0,0,1,0,0,0)
		16: # Care for Bargin
			# 15
			GlobalVariables.gCurrentStoryID = int (16)
			story.text = playerName+" : \"Bargin could use some medical care, do you have a healer in the village who can look after him while we are gone?\"[p]Avelina : \"Of course! Marie, the Innkeeper's wife, is skilled with herbs and has mended more than one bone in her lifetime. I'll go grab her and we'll help your friend get to the inn.\""
			optionOne.text = "Talk To Marcus"
			optionOne.tooltip_text = "8"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		17: 
			# 15
			GlobalVariables.gCurrentStoryID = int (17)
			if playerBackground == "Merchant":
				story.text = playerName+ " : If we are able to track down the goblins and rescue the children, I would like to do some bartering before Bargin and I leave, hopefully at a discounted price.\"[p]"
				optionOne.text = "Continue"
				optionOne.tooltip_text = "18"
			elif playerBackground == "Bounty Hunter":
				story.text = playerName+" : \"I'm an accomplished bounty hunter and I don't work for free. We need to discuss my payment before I fully commit to helping you.\""
				optionOne.text ="Continue"
				optionOne.tooltip_text = "20"
			elif playerBackground == "Ruined":
				story.text = playerName+" : I've recently ran in to a bit of bad luck, and as it were, I have nothing but the clothes on my back and a few provisions in my pack. If I am to help, I will need some supplies and a decent weapon.\""
				optionOne.text = "Continue"
				optionOne.tooltip_text = "21"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		18:
			# 17
			GlobalVariables.gCurrentStoryID = int (18)
			story.text = flavorText+"Marcus nods his head"+flavorTextStop+"Marcus : \"I'll need to talk to our blacksmith and the shopkeeper, but I'm confident we can accomadate that request."
			optionOne.text = "Follow Goblins"
			optionOne.tooltip_text = "12"
			GUI._enable_buttons(1,0,0,0,0,0)
		19: 
			# 20
			GlobalVariables.gCurrentStoryID = int (19)
			story.text = flavorText+ "Marcus looks at you with disdain"+flavorTextStop+"[p]Marcus : I know this isn't your village and the goblins are not your problem, but asking for money from us leaves an ill taste in my mouth. We don't have much choice though, very well.\"[p]"+flavorText+"Marcus walk over to a rotund man with a chain around his neck with a charm in the shape of weighing scales. A sign of moneychangers in most smaller villages. This man would be in charge of weighing coins and running the village treasury. After a short conversation and some exchanging of gold, Marcus makes his way back to you, pouch of gold in hand."
			playerGold += (GlobalVariables.gCharacterStr * 2) + playerGold
			optionOne.text = "Take Gold"
			optionOne.tooltip_text = "23"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		20:
			#17 Bouny Hunter
			GlobalVariables.gCurrentStoryID = int (20)
			story.text = playerName+" : I'm an accomplished bounty hunter with excellent tracking skills and I handle myself well in a fight. I don't work for free though. We need to discuss payment for my services.\""
			optionOne.text = str(GlobalVariables.gCharacterStr * 2) + " Gold"
			optionOne.tooltip_text = "19"
			optionTwo.text = str(GlobalVariables.gCharacterCha * 3) + " Gold"
			optionTwo.tooltip_text = "24"
			GUI._enable_buttons(1,1,0,0,0,0)
		21:
			#17 Ruined
			GlobalVariables.gCurrentStoryID = int (21)
			story.text = "Marcus: \"We have a fairly accomplished blacksmith in town. If you give me a moment to speak with him, I'm positive he will provide you with some gear in return for your help.\""
			optionOne.text = "Wait"
			optionOne.tooltip_text = "26"
			GUI._enable_buttons(1,0,0,0,0,0)
		22:
			# 11 Grabbed weapon
			GlobalVariables.gCurrentStoryID = int (22)
			story.text = flavorText+"You reach down and grab the sword, adding it to your pack. You feel the ever so slight tingle sensation that always comes from handling magical objects. "
			if Achievements.gkFoundShortSwordofSeeing != true:
				Achievements._single_save("GOBLIN_KING", "Found_Shortsword_of_Seeing", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You found the Shortsword of Seeing")
			GlobalVariables.gPlayerWeapon.append("Shortsword of Seeing")
			GUI.inventoryScreen._populate_inventory()
			if talkedToMarcus == false:
				optionTwo.text = "Town Center"
				optionTwo.tooltip_text = "3"
			optionOne.text = "Follow Goblins"
			optionOne.tooltip_text = "12"
			
		23:
			# 19,24
			GlobalVariables.gCurrentStoryID = int (23)
			_update_middle_spawn("bagOfGold")
			story.text = flavorText+"You take the bag of gold from Marcus and add it to your pack."+flavorTextStop+"[p]"+playerName+" : \"Now that the matter of my payment is taken care of, let's start tracking the goblins before the sun full sets and it gets too dark to track them. \""
			optionOne.text = "Follow Goblins"
			optionOne.tooltip_text = "12"
			GUI._enable_buttons(1,0,0,0,0,0)
			
		24:
			# 20
			GlobalVariables.gCurrentStoryID = int (24)
			story.text = flavorText+ "Marcus looks at you with disdain"+flavorTextStop+"[p]Marcus : I know this isn't your village and the goblins are not your problem, but asking for money from us leaves an ill taste in my mouth. We don't have much choice though, very well.\"[p]"+flavorText+"Marcus walk over to a rotund man with a chain around his neck with a charm in the shape of weighing scales. A sign of moneychangers in most smaller villages. This man would be in charge of weighing coins and running the village treasury. After a short conversation and some exchanging of gold, Marcus makes his way back to you, pouch of gold in hand."
			playerGold += (GlobalVariables.gCharacterCha * 3) + playerGold
			optionOne.text = "Take Gold"
			optionOne.tooltip_text = "23"
			GUI._enable_buttons(1,0,0,0,0,0)
		25:
			#3
			_reset_background()
			_update_background_scene("potionShop", 1)
			GlobalVariables.gCurrentStoryID = int (25)
			if Achievements.gkStoleFromShop != true:
				Achievements._single_save("GOBLIN_KING", "Stole_From_Shop", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You stole from the villagers.")
			story.text = "While everyone is focused on the man speaking, you decide to enter a nearby shop with an herbalist sign hanging on its side. Inside you are able to quickly swipe a couple potions and add them to your pack."
			optionOne.text = "Talk to Marcus"
			GlobalVariables.gPlayerPotion.append("Healing Potion")
			GlobalVariables.gPlayerPotion.append("Fire Breath Potion")
			GUI.inventoryScreen._populate_inventory()
			optionOne.tooltip_text = 4
			GUI._enable_buttons(1,0,0,0,0,0)
		
		26:
			#21
			GlobalVariables.gCurrentStoryID = int (26)
			story.text = flavorText+"Marcus walks off to talk to a burly man not far away. After a short conversation, the man nods his head and walks off. Shortly, he returns with a mace and some chainmail armor.[p]Marcus: \"Perrin, the blacksmith, said this mace and chainmail armor were traded to him by a traveler passing through in return for repairing some horseshoes and a broken wagon axel. They are better than your basic stuff, and he's had a hard time selling them since no one around here has need for such things. He says they are yours to keep for helping us.\""
			GlobalVariables.gPlayerArmor.append("Chainmail of the Forgotten Warrior")
			GlobalVariables.gPlayerWeapon.append("Combatant's Mace")
			GUI.inventoryScreen._populate_inventory()
			optionOne.text = "Continue"
			optionOne.tooltip_text = "8"
			GUI._enable_buttons(1,0,0,0,0,0)
		27:
			#15
			GlobalVariables.gCurrentStoryID = int (27)
			if playerRace == "Shadar-kai":
				story.text = playerName+": \"I will bring pain to these goblins but in doing so I will upset the natural order of things. I will require payment once I return.\"[p]Marcus: \"Of course. I'll have Avelina talk to everyone and see what we can gather while you are gone.\""
				optionOne.text = "Continue"
				optionOne.tooltip_text = "8"
				GUI._enable_buttons(1,0,0,0,0,0)
			if playerRace == "Dwarf":
				story.text = playerName+": \"Nothing would give me more pleasure than crackin some goblin heads together. Just make sure there's plenty of ale waiting for me when I get back!\""
				optionOne.text = "Continue"
				optionOne.tooltip_text = "8"
				GUI._enable_buttons(1,0,0,0,0,0)
			if playerRace == "Gnome":
				story.text = playerName+": \"Gnomes and goblins have been enemies for longer than anyone can remember. I'll do what I can to rescue the children and when I get back, we'll have a celebration the likes this village has never seen before!\""
				optionOne.text = "Continue"
				optionOne.tooltip_text = "8"
				GUI._enable_buttons(1,0,0,0,0,0)
			

func _act_two(storyID):
	match storyID:
		0:
			GlobalVariables.gCurrentStoryID = int (0)
			_reset_background()
			GUI._update_story_and_act()
			if visitedPond == false:
				story.text = "While tracking the goblins through the woods, you come to an area where a couple goblins seem to have veered off down a different path. No more than 2 from what you can tell."
				optionOne.text = "Keep Tracking"
				optionOne.tooltip_text = "1"
				optionTwo.text = "Veer Right"
				optionTwo.tooltip_text = "2"
				GUI._enable_buttons(1,1,0,0,0,0)
			elif visitedPond == true:
				story.text = "As you leave the pond, the trees seem to close behind you, blocking your access to the path you have left."
				optionOne.text = "Track Goblins"
				optionOne.tooltip_text = "1"
				GUI._enable_buttons(1,0,0,0,0,0)
		1:
			GlobalVariables.gCurrentStoryID = int (1)
			story.text = flavorText+"You follow the goblins until the darkness hinders your ability to see their tracks."
			optionOne.text = "Camp Here"
			optionOne.tooltip_text = "23"
			GUI._enable_buttons(1,0,0,0,0,0)
			if GlobalVariables._item_check("Shortsword of Seeing"):
				optionTwo.text = "Shortsword"
				optionTwo.tooltip_text = "22"
				GUI._enable_buttons(0,1,0,0,0,0)
		
		2:
			GlobalVariables.gCurrentStoryID = int(2)
			visitedPond = true
			story.text = "You follow the set of goblin tracks to a clearing with a large pond. However, there are no signs of the goblins anywhere."
			optionOne.text = "Look Around"
			optionOne.tooltip_text = "3"
			optionTwo.text = "Examine Pond"
			optionTwo.tooltip_text = "4"
			optionThree.text = "Leave Area"
			optionThree.tooltip_text = "0"
			GUI._enable_buttons(1,1,1,0,0,0)
		3:
			GlobalVariables.gCurrentStoryID = int (3)
			story.text = "You manage to pick up the goblin's tracks again, and they lead to the west edge of the pond. From there, they turn into smear marks, as if the goblins were pulled into the pond by something."
			optionOne.text = "Examine Pond"
			optionOne.tooltip_text = "4"
			optionTwo.text = "Leave Area"
			optionTwo.tooltip_text = "0"
			GUI._enable_buttons(1,1,0,0,0,0)
		4:
			GlobalVariables.gCurrentStoryID = int (4)
			story.text = "As you draw closer to the pond, the water seems to take on a slight glow. You can feel something tugging at your mind as the urge to put your hand into the water grows stronger and stronger."
			optionOne.text = "Touch Water"
			optionOne.tooltip_text = "6"
			GUI._enable_buttons(1,0,0,0,0,0)
			if GlobalVariables.gCharacterWis >= 12:
				optionTwo.text = "Pull Back"
				optionTwo.tooltip_text = "5"
				GUI._enable_buttons(0,1,0,0,0,0)
		5:
			GlobalVariables.gCurrentStoryID = int(5)
			optionOne.text = "Touch Water"
			optionOne.tooltip_text = "6"
			optionTwo.text = "Leave Area"
			optionTwo.tooltip_text = "0"
			GUI._enable_buttons(1,1,0,0,0,0)
		6:
			GlobalVariables.gCurrentStoryID = int (6)
			story.text = flavorText+"You dip your hand into the water and a tingle runs up your arm and seemingly into your mind."+flavorTextStop+"[p]Arigash : \"Welcome. I am Arigash, or as visitors have often called me, The Trader's Pond. I am bound here to trade with travellers, though I can only make one trade per day. If you toss something into my waters and focus on what you want in return, I will attempt to trade from my pools something of equal value.\""
			optionOne.text = "Decline"
			optionOne.tooltip_text = "7"
			optionTwo.text = "Trade"
			optionTwo.tooltip_text = "8"
			optionThree.text = "Questions"
			optionThree.tooltip_text = "10"
			GUI._enable_buttons(1,1,1,0,0,0)
			
		7:
			GlobalVariables.gCurrentStoryID = int(7)
			story.text = flavorText+"You attempt to pull your hand from the pond, but an unseen force keeps you from pulling it all the way out."+flavorTextStop+"[p]Arigash : My soul is bound to this pond until my duty has been fullfilled. Would you really deny me an opportunity to come closer to my freedom?\""
			optionOne.text = "Leave Area"
			optionOne.tooltip_text = "17"
			optionTwo.text = "Trade"
			optionTwo.tooltip_text = "8"
			GUI._enable_buttons(1,1,0,0,0,0)
			
		8:
			GlobalVariables.gCurrentStoryID = int(8)
			story.text = "What would you like to toss into the pond?"
			optionOne.text = "Item"
			optionOne.tooltip_text = "9"
			optionTwo.text = "Gold"
			optionTwo.tooltip_text = "14"
			if GlobalVariables.acceptedMarcusHelp == true:
				optionThree.text = "Marcus"
				optionThree.tooltip_text = "15"
				GUI._enable_buttons(0,0,1,0,0,0)
			GUI._enable_buttons(1,1,0,0,0,0)
		9:
			GlobalVariables.gCurrentStoryID = int (9)
			story.text = flavorText+"You reach into your pack for an item to exchange. What type of item do you want to toss into the pond?"
			if GlobalVariables.gPlayerWeapon.is_empty() != true:
				optionOne.text = "Weapon"
				optionOne.tooltip_text = "19"
				GUI._enable_buttons(1,0,0,0,0,0)
			if GlobalVariables.gPlayerArmor.is_empty() != true:
				optionTwo.text = "Armor"
				optionTwo.tooltip_text = "20"
				GUI._enable_buttons(0,1,0,0,0,0)
				# 21 already taken, needs fixed
			#if GlobalVariables.gPlayerPotion.is_empty() != true:
				#optionThree.text = "Potion"
				#optionThree.tooltip_text = "21"
				#GUI._enable_buttons(0,0,1,0,0,0)
				# 22 is already taken, will need to fix this later
			#if GlobalVariables.gPlayerArtifact.is_empty() != true:
				#optionFour.text = "Relic"
				#optionFour.tooltip_text = "22"
				#GUI._enable_buttons(0,0,0,1,0,0)
		10:
			GlobalVariables.gCurrentStoryID = int (10)
			story.text = "Arigash : \"I can sense you have questions. What would you like to know?\""
			optionOne.text = "Story"
			optionOne.tooltip_text = "11"
			optionTwo.text = "Tradeable"
			optionTwo.tooltip_text = "12"
			optionThree.text = "Suspicious"
			optionThree.tooltip_text = "13"
			GUI._enable_buttons(1,1,1,0,0,0)
		11:
			GlobalVariables.gCurrentStoryID = int (11)
			pondStory = true
			story.text = "Arigash : \"Long ago I served as an apprentice to a Wizard who lived in this area. He taught me the basics of magic, but refused to give me lessons on anything other than the most rudimentary cantrips and spells. I started to feel as if I was more of a chore boy than an apprentice and eventually I let my emotions get the better of me. I attempted to kill him while he slept so I could take his spellbooks for my own and learn more about the magical arts. Things did not turn out well for me though and after killing me, he bound my soul to the waters of this pond, though it was big enough to be called a lake at the time. Think of it as a community service. I must help 10,000 travellers by trading with them so my soul can be released and I can finally move on.\""
			optionOne.text = "Trade"
			optionOne.tooltip_text = "8"
			optionTwo.text = "Decline"
			optionTwo.tooltip_text = "7"
			GUI._enable_buttons(1,1,0,0,0,0)
			if pondTradable == false:
				optionThree.text = "Tradeable"
				optionThree.tooltip_text = "12"
				GUI._enable_buttons(0,0,1,0,0,0)
			if pondSus == false:
				optionFour.text = "Suspicious"
				optionFour.tooltip_text = "13"
				GUI._enable_buttons(0,0,0,1,0,0)
		12:
			GlobalVariables.gCurrentStoryID = int(12)
			pondTradable == true
			story.text = "Arigash: \"I will accept an item which I deem to have value. Most travellers trade their old armor or weapon in exchange for something they need. Sentient life also has value, and in the past, some have offered their companions in hopes of gaining a more power item in exchange.\""
			optionOne.text = "Trade"
			optionOne.tooltip_text = "8"
			optionTwo.text = "Decline"
			optionTwo.tooltip_text = "7"
			GUI._enable_buttons(1,1,0,0,0,0)
			if pondStory == false:
				optionThree.text = "Story"
				optionThree.tooltip_text = "11"
				GUI._enable_buttons(0,0,1,0,0,0)
			if pondSus == false:
				optionFour.text = "Suspicious"
				optionFour.tooltip_text = "13"
				GUI._enable_buttons(0,0,0,1,0,0)
		13:
			GlobalVariables.gCurrentStoryID = int(13)
			pondSus = true
			story.text = GlobalVariables.gCharacterName+" : \"I am wary of deals that seem too good to be true. What is the catch here?\"[p]Arigash : \"I understand your hesitancy, many who find me are hesitant at first. I cannot promise the item I return to you will be equally as valuable, but it will be close.\""
			optionOne.text = "Trade"
			optionOne.tooltip_text = "8"
			optionTwo.text = "Decline"
			optionTwo.tooltip_text = "7"
			GUI._enable_buttons(1,1,0,0,0,0)
			if pondStory == false:
				optionThree.text = "Story"
				optionThree.tooltip_text = "11"
				GUI._enable_buttons(0,0,1,0,0,0)
			if pondTradable == false:
				optionFour.text = "Tradeable"
				optionFour.tooltip_text = "12"
				GUI._enable_buttons(0,0,0,1,0,0)
				
		14:
			GlobalVariables.gCurrentStoryID = int (14)
			if playerGold > 49:
				optionOne.text = "50 Gold"
				optionOne.tooltip_text = "21"
				GUI._enable_buttons(1,0,0,0,0,0)
			if playerGold > 99:
				optionTwo.text = "100 Gold"
				optionTwo.tooltip_text = "21"
				GUI._enable_buttons(0,1,0,0,0,0)
			if playerGold > 149:
				optionThree.text = "150 Gold"
				optionThree.tooltip_text = "21"
				GUI._enable_buttons(0,0,1,0,0,0)
			optionFour.text = "Trade Item"
			optionFour.tooltip_text = "9"
			optionFive.text = "Leave Area"
			optionFive.tooltip_text = "7"
			GUI._enable_buttons(0,0,0,1,1,0)
		15:
			GlobalVariables.gCurrentStoryID = int(15)
			story.text = flavorText+"You ponder what type of item you could get by offering Marcus to the pool. What is a sentient being worth?"
			optionOne.text = "Sacrifice Marcus"
			optionOne.tooltip_text = "26"
			optionTwo.text = "Offer Item"
			optionTwo.tooltip_text = "9"
			optionThree.text = "Offer Gold"
			optionThree.tooltip_text = "14"
			optionFour.text = "Leave Area"
			optionFour.tooltip_text = "7"
			GUI._enable_buttons(1,1,1,1,0,0)
		16:
			GlobalVariables.gCurrentStoryID = int (16)
			story.text = "Arigash : \"[shake]You and all your belongings will feed my hunger! [/shake][p]"+flavorText+"The pond's waters shift in color, raking on a reddish hue."
			await get_tree().create_timer(2).timeout
			var startBattle = arigashBattle.instantiate()
			add_child(startBattle)
			optionOne.text = "Continue"
			optionOne.tooltip_text = "18"
			await get_tree().create_timer(2).timeout
			GUI._enable_buttons(1,0,0,0,0,0)
			
		17:
			GlobalVariables.gCurrentStoryID = int (17)
			story.text = flavorText+"The pond's waters shift in color, taking on a reddish hue."+flavorTextStop+"[p]Arigash : \"[shake]If you will not trade with me, I will make you and all your belongings a part of my collection![/shake]\""
			await get_tree().create_timer(2).timeout
			var startBattle = arigashBattle.instantiate()
			add_child(startBattle)
			optionOne.text = "Continue"
			optionOne.tooltip_text = "18"
			await get_tree().create_timer(2).timeout
			GUI._enable_buttons(1,0,0,0,0,0)
		18:
			GlobalVariables.gCurrentStoryID = int (18)
			story.text = flavorText+"Arigash collapses into a puddle and is slowly absorbed by the ground. The only thing left is a pair of matching bands he wore around his wrists. You retrieve them and add them to your pack."
			GlobalVariables.gPlayerArtifact.append("Bands of Speed")
			GUI.inventoryScreen._populate_inventory()
			if Achievements.gkDefeatTheTraitor != true:
				Achievements._single_save("GOBLIN_KING", "Defeat_The_Traitor", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You defeated Argiash the Traitor")
			optionOne.text = "Leave"
			optionOne.tooltip_text = "0"
			GUI._enable_buttons(1,0,0,0,0,0)
		19:
			GlobalVariables.gCurrentStoryID = int (19)
			story.text = flavorText+"You think about the various weapons in your pack and what would make a good trade. With your connection to Arigash, you can feel his excitement and also...something else. A sinister hunger barely contained. You sense the threat of an attack and pull back from pond in a rush."
			if Achievements.gkOfferedItemToPond != true:
				Achievements._single_save("GOBLIN_KING", "Offer_Item_To_Traitors_Pond", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You offered an item to the Trader's Pond")
			optionOne.text = "Continue"
			optionOne.tooltip_text = "16"
			GUI._enable_buttons(1,0,0,0,0,0)
		20:
			GlobalVariables.gCurrentStoryID = int (20)
			story.text = flavorText+"You think about the various armors in your pack and what would make a good trade. With your connection to Arigash, you can feel his excitement and also...something else. A sinister hunger barely contained. You sense the threat of an attack and pull back from pond in a rush."
			if Achievements.gkOfferedItemToPond != true:
				Achievements._single_save("GOBLIN_KING", "Offer_Item_To_Traitors_Pond", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You offered an item to the Trader's Pond")
			optionOne.text = "Continue"
			optionOne.tooltip_text = "16"
			GUI._enable_buttons(1,0,0,0,0,0)
		21:
			GlobalVariables.gCurrentStoryID = int (21)
			story.text = flavorText+"You reach into your pouch to grab the gold. With your connection to Arigash, you can feel his excitement and also...something else. A sinister hunger barely contained. You sense the threat of an attack and pull back from pond in a rush."
			if Achievements.gkOfferedGoldToPond != true:
				Achievements._single_save("GOBLIN_KING", "Offer_Gold_To_Traitors_Pond", true)
				var newAch = achPopup.instantiate()
				add_child(newAch)
				newAch._ach_popup("You offered gold to the Trader's Pond")
			optionOne.text = "Continue"
			optionOne.tooltip_text = "16"
			GUI._enable_buttons(1,0,0,0,0,0)
		22:
			GlobalVariables.gCurrentStoryID = int (22)
			story.text = flavorText+"You notice your shortsword is emitting a faint glow. By focusing on it, you are able to control how dim or bright the glow becomes. You could use this to continue tracking the goblins, or you could rest for the night."
			optionOne.text = "Make Camp"
			optionOne.tooltip_text = "23"
			optionTwo.text = "Track Goblins"
			optionTwo.tooltip_text = "24"
			GUI._enabled_buttons(1,1,0,0,0,0)
		23:
			GlobalVariables.gCurrentStoryID = int (23)
			story.text = flavorText+"You set camp for the night and awaken early in the morning to continue tracking the goblins."
			dayCounter += 1
			optionOne.text = "Continue"
			optionOne.tooltip_text = "24"
			GUI._enable_buttons(1,0,0,0,0,0)
		24:
			GlobalVariables.gCurrentStoryID = int (24)
			story.text = "You follow the goblins until the path narrows and enters into a gully. While making your way through the gully you hear grunts coming from ahead. Slowly, you move along the path until you can see an injured boar lying on the ground with two other boars nearby. The carcass of another boar lies near a few logs that appear hastily cut. It would seem the goblins killed a boar for dinner and left a second boar near death. Getting past them might be tricky."
			optionOne.text = "Charge Through"
			optionOne.tooltip_text = "25"
			optionTwo.text = "Find New Path"
			optionTwo.tooltip_text = "27"
			GUI._enable_buttons(1,1,0,0,0,0)
			for i in GlobalVariables.gCharacterTraits:
				if i == "Wild Shape" or i == "Animal Handling" or i == "Sneak Attack" or i == "Teleport":
					optionThree.text = i
					optionThree.tooltip_text = "28"
					GUI._enable_buttons(0,0,1,0,0,0)
		25:
			GlobalVariables.gCurrentStoryID = int (25)
			story.text = "You attempt to rush forward and bypass the boars before they have a chance to react. However, the largest boar reacts more quickly than you anticipated."
			await get_tree().create_timer(2).timeout
			var startBattle = boarbattle.instantiate()
			add_child(startBattle)
			optionOne.text = "Continue"
			optionOne.tooltip_text = "29"
			await get_tree().create_timer(2).timeout
			GUI._enable_buttons(1,0,0,0,0,0)
		
		26:
			GlobalVariables.gCurrentStoryID = int (26)
			story.text = flavorText+"You contemplate pushing Marcus into the Trader's Pond. With your connection to Arigash, you can feel his excitement and also...something else. A sinister hunger barely contained. You sense the threat of an attack and pull back from pond in a rush."+flavorTextStop+"[p]Arigash : \"[wave]Why settle for one, when I can devour you both!\""
			await get_tree().create_timer(2).timeout
			var startBattle = arigashBattle.instantiate()
			add_child(startBattle)
			optionOne.text = "Continue"
			optionOne.tooltip_text = "18"
			await get_tree().create_timer(2).timeout
			GUI._enable_buttons(1,0,0,0,0,0)
		
		27:
			GlobalVariables.gCurrentStoryID = int (27)
			story.text = flavorText+"You double back along the path and look for an alternate route to avoid the boars. While you do manage to find a safe passage around the boars, it cost valuable time."
			optionOne.text = "Continue"
			optionOne.tooltip_text = "31"
			GUI._enable_buttons(1,0,0,0,0,0)
		
		28:
			GlobalVariables.gCurrentStoryID = int (28)
			if GlobalVariables.gCharacterTraits.has("Animal Handling"):
				story.text = flavorText+"You reach into your pack for a few root vegetables you had gathered earlier. With slow, cautious steps, you slowly move closer to the boars and they keep a wary eye upon you. Once you are close enough, you lay the vegetables on the ground and slowly move past the boars as they start to investigate your offering."
				optionOne.text = "Continue"
				optionOne.tooltip_text = "31"
				GUI._enable_buttons(1,0,0,0,0,0)
				if Achievements.gkAnimalHandling != true:
					Achievements._single_save("GOBLIN_KING", "Used_Animal_Handling_To_Pass_Boars", true)
					var newAch = achPopup.instantiate()
					add_child(newAch)
					newAch._ach_popup("You displayed your skill with handling animals")
			elif GlobalVariables.gCharacterTraits.has("Wild Shape"):
				story.text = flavorText+"Concentrating on an image in your mind, you slowly transform yourself into a meerkat. With this form, you are easily able to sneak past the wild boars."
				optionOne.text = "Continue"
				optionOne.tooltip_text = "31"
				GUI._enable_buttons(1,0,0,0,0,0)
				if Achievements.gkWildShape != true:
					Achievements._single_save("GOBLIN_KING", "Used_Wild_Shape_To_Pass_Boars", true)
					var newAch = achPopup.instantiate()
					add_child(newAch)
					newAch._ach_popup("Disguised yourself as a meerkat to bypass the boars")
			elif GlobalVariables.gCharacterTraits.has("Stealth"):
				story.text = "Using your years of training, you stealthily pass the boars and continue along the path."
				optionOne.text = "Continue"
				optionOne.tooltip_text = "31"
				GUI._enable_buttons(1,0,0,0,0,0)
				if Achievements.gkStealth != true:
					Achievements._single_save("GOBLIN_KING", "Used_Stealth_To_Pass_Boars", true)
					var newAch = achPopup.instantiate()
					add_child(newAch)
					newAch._ach_popup("You have unrivaled stealth skills")
			elif GlobalVariables.gCharacterTraits.has("Teleport"):
				story.text = "Story paths ends here for this path of choices."
				optionOne.text = "Continue"
				optionOne.tooltip_text = "31"
				GUI._enable_buttons(1,0,0,0,0,0)
				if Achievements.gkTeleport != true:
					Achievements._single_save("GOBLIN_KING", "Used_Teleport_To_Pass_Boars", true)
					var newAch = achPopup.instantiate()
					add_child(newAch)
					newAch._ach_popup("When in doubt...teleport!")
			else:
				story.text = "This should never appear. If it did, please report a bug with Goblin King Act 2 ID 28. Congratulations, you managed to bypass the boars with a bug in the code!"
				optionOne.text = "Continue"
				optionOne.tooltip_text = "31"
				GUI._enable_buttons(1,0,0,0,0,0)
		
		29:
			GlobalVariables.gCurrentStoryID = int(29)
			story.text = "With the boars defeated, you are able to continue following the goblins. Hopefully the fighting did not waste too much time."
			optionOne.text = "Continue"
			optionOne.tooltip_text = "31"
			GUI._enable_buttons(1,0,0,0,0,0)
		
		30:
			GlobalVariables.gCurrentStoryID = int (30)
			# Currently unused
		
		31:
			GlobalVariables.gCurrentStoryID = int (31)
			story.text = "This is the current end of the story"

func _on_start_adventure_timeout():
	_act_one(GlobalVariables.gCurrentStoryID)
