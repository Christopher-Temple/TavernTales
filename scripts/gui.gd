extends Control

# Set an onready variable that gets the first node in the tree with the Adventure group
# That way we can call the function within that node when the three option buttons are 
# pressed.
@onready var storyUpdate = get_tree().get_first_node_in_group("Adventure")
@onready var confirmTheme = load("res://themes/ConfirmPopup.tres")
@onready var inventoryScreen = $Inventory
@onready var option_one: Button = $HBoxContainer/VBoxContainer6/OptionOne
@onready var option_two: Button = $HBoxContainer/VBoxContainer6/OptionTwo
@onready var option_three: Button = $HBoxContainer/VBoxContainer6/OptionThree
@onready var option_four: Button = $HBoxContainer/VBoxContainer6/OptionFour
@onready var option_five: Button = $HBoxContainer/VBoxContainer6/OptionFive
@onready var option_six: Button = $HBoxContainer/VBoxContainer6/OptionSix
@onready var inventory: Button = $HBoxContainer/VBoxContainer6/Inventory
@onready var test_fight: Button = $HBoxContainer/VBoxContainer6/TestFight



# Called when the node enters the scene tree for the first time.
func _ready():
	_set_stats()
	_debug_show_hide()
	_update_story_and_act()

func _update_story_and_act():
	$NameAndAct.text = "[center]"+GlobalVariables.adventureName+" : Act "+str(GlobalVariables.act)

func _inventory_changed(equipment):
	$AdventureText.newline()
	$AdventureText.add_text("You have equipped " + equipment)

func _set_stats():
	$Name.text = "[center]" + GlobalVariables.gCharacterName
	$RaceAndClass.text = "[center]" + GlobalVariables.gCharacterRace +"  "+ GlobalVariables.gCharacterClass
	$Background.text = "[center]" + GlobalVariables.gCharacterBackground
	$Str.text = "[center]Str: " + str(GlobalVariables.gCharacterStr)
	$Dex.text = "[center]Dex: " + str(GlobalVariables.gCharacterDex)
	$Con.text = "[center]Con: " + str(GlobalVariables.gCharacterCon)
	$Wis.text = "[center]Wis: " + str(GlobalVariables.gCharacterWis)
	$Cha.text = "[center]Cha: " + str(GlobalVariables.gCharacterCha)
	

func _player_take_damage(amount):
	$HealthBar.value -= amount

func _player_heal_damage(amount):
	$HealthBar.value += amount

func _player_lose_mana(amount):
	$ManaBar.value -= amount

func _player_gain_mana(amount):
	$ManaBar.value += amount
	
func _disable_all_buttons():
	# Sets all the buttons to disabled and reverts their text back to Default
	option_one.text = "Disabled"
	option_one.tooltip_text = ""
	option_one.disabled = true
	
	option_two.text = "Disabled"
	option_two.tooltip_text = ""
	option_two.disabled = true
	
	option_three.text = "Disabled"
	option_three.tooltip_text = "" 
	option_three.disabled = true
	
	option_four.text = "Disabled"
	option_four.tooltip_text = "" 
	option_four.disabled = true
	
	option_five.text = "Disabled"
	option_five.tooltip_text = "" 
	option_five.disabled = true
	
	option_six.text = "Disabled"
	option_six.tooltip_text = "" 
	option_six.disabled = true
	

func _enable_buttons(one, two, three, four, five, six):
	if one == 1:
		option_one.disabled = false
	if two == 1:
		option_two.disabled = false 
	if three == 1:
		option_three.disabled = false
	if four == 1:
		option_four.disabled = false
	if five == 1:
		option_five.disabled = false
	if six == 1:
		option_six.disabled = false

func _on_option_one_pressed():
	# the tooltip text is set by the adventure node and is used to determine what 
	# the next step in the adventure is. So here, we get the tooltip text, set the
	# global variable for the current story ID so when the player checks their equipment
	# we can use that global variable to repeat the last block of text after they look at 
	# equipment.
	var option = int(option_one.tooltip_text)
	
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)
	

func _on_option_one_2_pressed():
	var option = int(option_two.tooltip_text)
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)
	

func _on_option_one_3_pressed():
	var option = int(option_three.tooltip_text)
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)
	

func _on_option_one_button_down():
	$Click.play()
func _on_option_one_2_button_down():
	$Click.play()
func _on_option_one_3_button_down():
	$Click.play()
func _on_option_one_4_button_down() -> void:
	$Click.play()

func _on_option_one_4_pressed() -> void:
	var option = int(option_four.tooltip_text)
	$StoryID.text = "[center]ID: " + str(GlobalVariables.gCurrentStoryID)
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)

func _debug_show_hide():
	if GlobalVariables.debugMode == true:
		$StoryID.show()
	elif GlobalVariables.debugMode == false:
		$StoryID.hide()

func _on_option_one_5_pressed():
	var option = int(option_five.tooltip_text)
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)

func _on_button_pressed():
	inventoryScreen._show_inventory()

func _on_line_edit_text_submitted(new_text):
	if new_text == "debug on":
		$StoryID.show()
		$LineEdit.clear()
	elif new_text == "debug off":
		$StoryID.hide()
		$LineEdit.clear()
	else:
		
		var textToInt = int(new_text)
		if textToInt == int(1):
			storyUpdate._act_one(textToInt)
		elif textToInt == int(2):
			storyUpdate._act_two(textToInt)
		$LineEdit.clear()

func _on_option_one_6_pressed():
	var option = int(option_six.tooltip_text)
	_disable_all_buttons()
	if GlobalVariables.act == 1:
		storyUpdate._act_one(option)
	elif GlobalVariables.act == 2:
		storyUpdate._act_two(option)
	
func _process(delta):
	_console()
	$StoryID.text = "[center]ID: " + str(GlobalVariables.gCurrentStoryID)

func _console():
	if Input.is_action_just_pressed("Console"):
		if $LineEdit.visible == false:
			$LineEdit.clear()
			$LineEdit.show()
			$LineEdit.grab_focus()
		else:
			$LineEdit.hide()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BattleMaps/forest_fight.tscn")
