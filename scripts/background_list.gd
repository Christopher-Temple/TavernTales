extends ItemList

func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/race_tooltip.tscn").instantiate()
	tooltip.get_node("Panel/MarginContainer/RichTextLabel").text = str(TavernDictonary.backgroundInformation[for_text+"Stats"]).replace("\"","").replace("{","[center]").replace("}","").replace(",","[p][center]")
	tooltip.get_node("RichTextLabel2").text = "[center]Stats"
	tooltip.get_node("Panel/MarginContainer2/TraitLabel").text = "[center]Traits[p][center]"+TavernDictonary.backgroundInformation[for_text+"Traits"]
	return tooltip
