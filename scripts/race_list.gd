extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/race_tooltip.tscn").instantiate()
	tooltip.get_node("Panel/MarginContainer/RichTextLabel").text = str(TavernDictonary.raceInformation[for_text+"Stats"]).replace("\"","").replace("{","[center]").replace("}","").replace(",","[p][center]")
	tooltip.get_node("RichTextLabel2").text = "[center]Stats"
	tooltip.get_node("Panel/MarginContainer2/TraitLabel").text = "[center]Traits[p][center]"+TavernDictonary.raceInformation[for_text+"Traits"]
	return tooltip
