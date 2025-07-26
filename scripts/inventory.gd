extends Control

@onready var tree = $Tree
@onready var root = tree.create_item()
@onready var weapons = tree.create_item(root)
@onready var armor = tree.create_item(root)
@onready var potions = tree.create_item(root)
@onready var artifacts = tree.create_item(root)
@onready var questItems = tree.create_item(root)
@onready var inventory = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	_populate_inventory()
	_set_default_gear()

func _set_default_gear():
	GlobalVariables.gEquippedArmor = GlobalVariables.gPlayerArmor[0]
	GlobalVariables.gEquippedWeapon = GlobalVariables.gPlayerWeapon[0]
	
func _populate_inventory():
	root.set_text(0,"Backpack")
	weapons.set_text(0, "Weapons")
	armor.set_text(0, "Armor")
	potions.set_text(0, "Potions")
	artifacts.set_text(0, "Artifacts")
	questItems.set_text(0, "Quest Items")
	
	for i in GlobalVariables.gPlayerArmor:
		var armorName = i
		armorName = tree.create_item(armor) 
		armorName.set_text(0, i)

	for j in GlobalVariables.gPlayerArtifact:
		var artifactName = j
		artifactName = tree.create_item(artifacts)
		artifactName.set_text(0,j)

	for k in GlobalVariables.gPlayerPotion:
		var potionName = k
		potionName = tree.create_item(potions)
		potionName.set_text(0,k)

	for l in GlobalVariables.gPlayerQuestItem:
		var questItemName = l
		questItemName = tree.create_item(questItems)
		questItemName.set_text(0,l)

	for m in GlobalVariables.gPlayerWeapon:
		var weaponName = m
		weaponName = tree.create_item(weapons)
		weaponName.set_text(0,m)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_item_selected():
	var selectedItem = tree.get_selected()
	var printTarget = get_tree().get_first_node_in_group("GUI")
	if selectedItem.get_parent() == armor :
		GlobalVariables.gEquippedArmor = selectedItem.get_text(0)
		printTarget._inventory_changed(GlobalVariables.gEquippedArmor)
	elif selectedItem.get_parent() == weapons:
		GlobalVariables.gEquippedWeapon = selectedItem.get_text(0)
		printTarget._inventory_changed(GlobalVariables.gEquippedWeapon)
	else:
		pass

func _show_inventory():
	inventory.show()

func _on_button_pressed():
	inventory.hide()

func _add_item(name,section):
	var itemName = name
	if section == "weapon":
		itemName = tree.create_item(weapons)
		itemName.set_text(0,name)
	elif section == "armor":
		itemName = tree.create_item(armor)
		itemName.set_text(0,name)
	elif section == "artifact":
		itemName = tree.create_item(artifacts)
		itemName.set_text(0,name)
	elif section == "questItem":
		itemName = tree.create_item(questItems)
		itemName.set_text(0,name)
	elif section == "potion":
		itemName = tree.create_item(potions)
		itemName.set_text(0,name)
