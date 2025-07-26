extends Control

@onready var item_list: ItemList = $ItemList

var achievementsSavePath = "user://Achievements.cfg"



var gkFoundShortSwordofSeeing = false
var gkStoleFromShop = false
var gkAcceptMarcusHelp = false
var gkDeclineMarcusHelp = false
var gkOfferedMarcusToPond = false
var gkOfferedGoldToPond = false
var gkOfferedItemToPond = false
var gkDefeatTheTraitor = false
var gkWildShape = false
var gkTeleport = false
var gkStealth = false
var gkAnimalHandling = false

func _ready() -> void:
	_load_achievements()

func _load_achievements():
	var achFile = ConfigFile.new()
	var err = achFile.load(achievementsSavePath)
	if err != OK:
		return
	else:
		gkFoundShortSwordofSeeing = achFile.get_value("GOBLIN_KING","Found_Shortsword_of_Seeing") # Added in story text
		gkStoleFromShop = achFile.get_value("GOBLIN_KING","Stole_From_Shop") # Added in story text
		gkAcceptMarcusHelp = achFile.get_value("GOBLIN_KING","Accept_Help_From_Marcus") # Added in story text
		gkDeclineMarcusHelp = achFile.get_value("GOBLIN_KING","Decline_Help_From_Marcus") # Added in story text
		gkOfferedMarcusToPond = achFile.get_value("GOBLIN_KING","Offer_Marcus_To_Traitors_Pond")# Added in story text
		gkOfferedGoldToPond = achFile.get_value("GOBLIN_KING","Offer_Gold_To_Traitors_Pond")# Added in story text
		gkOfferedItemToPond = achFile.get_value("GOBLIN_KING","Offer_Item_To_Traitors_Pond")# Added in story text
		gkDefeatTheTraitor = achFile.get_value("GOBLIN_KING","Defeat_The_Traitor")# Added in story text
		gkWildShape = achFile.get_value("GOBLIN_KING","Used_Wild_Shape_To_Pass_Boars")# Added in story text
		gkTeleport = achFile.get_value("GOBLIN_KING","Used_Teleport_To_Pass_Boars")# Added in story text
		gkStealth = achFile.get_value("GOBLIN_KING","Used_Stealth_To_Pass_Boars")# Added in story text
		gkAnimalHandling = achFile.get_value("GOBLIN_KING","Used_Animal_Handling_To_Pass_Boars")# Added in story text
	_update_achievement_list()

func _single_save(advenName, achName, value):
	var achFile = ConfigFile.new()
	achFile.load("user://Achievements.cfg")
	achFile.set_value(advenName,achName,value)
	achFile.save(achievementsSavePath)
	

func _update_achievement_list():
	if gkFoundShortSwordofSeeing == true:
		item_list.set_item_tooltip(0,"Found the Shortsword of Seeing")
		item_list.set_item_custom_fg_color(0, "Green")
	if gkStoleFromShop == true:
		item_list.set_item_tooltip(1,"Stole from the village shop")
		item_list.set_item_custom_fg_color(1, "Green")
	if gkAcceptMarcusHelp == true:
		item_list.set_item_tooltip(2,"Accepted the help of Marcus")
		item_list.set_item_custom_fg_color(2, "Green")
	if gkDeclineMarcusHelp == true:
		item_list.set_item_tooltip(3, "Declined the help of Marcus")
		item_list.set_item_custom_fg_color(3, "Green")
	if gkOfferedMarcusToPond == true:
		item_list.set_item_tooltip(4,"You tried to offer Marcus to the Traitor's Pond")
		item_list.set_item_custom_fg_color(4, "Green")
	if gkOfferedGoldToPond == true:
		item_list.set_item_tooltip(5,"You tried to offer gold to the Traitor's Pond")
		item_list.set_item_custom_fg_color(5, "Green")
	if gkOfferedItemToPond == true:
		item_list.set_item_tooltip(6,"You tried to offer an item to the Traitor's Pond")
		item_list.set_item_custom_fg_color(6, "Green")
	if gkDefeatTheTraitor == true:
		item_list.set_item_tooltip(7,"You have slain Arigash the Traitor.")
		item_list.set_item_custom_fg_color(7, "Green")
	if gkWildShape == true:
		item_list.set_item_tooltip(8,"Used Wild Shape to pass the boars.")
		item_list.set_item_custom_fg_color(8, "Green")
	if gkStealth == true:
		item_list.set_item_tooltip(9,"Used Stealth to pass the boars.")
		item_list.set_item_custom_fg_color(9, "Green")
	if gkTeleport == true:
		item_list.set_item_tooltip(10,"Teleported past the boars.")
		item_list.set_item_custom_fg_color(10, "Green")
	if gkAnimalHandling == true:
		item_list.set_item_tooltip(11,"Used Animal Handling to pass the boars.")
		item_list.set_item_custom_fg_color(11, "Green")


func _on_button_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")
