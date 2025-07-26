extends Control

var bugOrSuggestion : String
var textField : String

var url = "https://docs.google.com/forms/d/e/1FAIpQLSc-LkNJxOSA9WbnivsGvPzJpud9OxgO5jZetyZGwdYDXBTpgg/formResponse?submit=Submit"
var combinedString : String

func _ready() -> void:
	$AcceptBackground/AcceptDialog.get_ok_button().focus_mode = Control.FOCUS_NONE

func _on_bug_pressed() -> void:
	bugOrSuggestion = "&entry.1056227800=Bug"


func _on_check_box_pressed() -> void:
	bugOrSuggestion = "&entry.1056227800=Suggestion"

func _on_submit_pressed() -> void:
	$accept.play()
	textField = textField.replace(" ","+")
	combinedString = url+bugOrSuggestion+textField
	$AcceptBackground.show()
	$AcceptBackground/AcceptDialog.show()
	await get_tree().create_timer(0.5).timeout
	$HTTPRequest.request(combinedString)


func _on_return_pressed() -> void:
	$accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func _on_text_edit_text_changed() -> void:
	textField = "&entry.1423222662="+$TextEdit.text


func _on_accept_dialog_confirmed() -> void:
	$AcceptBackground.hide()
