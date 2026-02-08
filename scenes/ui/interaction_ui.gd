extends Control

@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MessageLabel
@onready var no_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton
@onready var yes_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/YesButton
@onready var ok_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/OkButton
@onready var take_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TakeButton

signal yes
signal no
signal ok
signal take

var grab_focus_once : bool = false
var current_interaction : Enum.Tool
var current_visit : Enum.Visit

func update_message(message : String):
	message_label.text = message

func _on_yes_button_pressed() -> void:
	yes.emit()

func _on_no_button_pressed() -> void:
	no.emit()
	

#For Visiting Inteations
func _on_ok_button_pressed() -> void:
	ok.emit(current_visit)
	ok_button.hide()
	take_button.hide()
	yes_button.show()
	no_button.show()

#For Taking Interations
func _on_take_button_pressed() -> void:
	take.emit(current_interaction)
	ok_button.hide()
	take_button.hide()
	yes_button.show()
	no_button.show()

func add_ok_button(visit: Enum.Visit):
	yes_button.hide()
	no_button.hide()
	ok_button.show()
	ok_button.grab_focus()
	current_visit = visit

func add_take_button(interaction : Enum.Tool):
	yes_button.hide()
	no_button.hide()
	take_button.show()
	take_button.grab_focus()
	current_interaction = interaction

func select():
	if grab_focus_once == false:
		no_button.grab_focus()
		ok_button.hide()
		take_button.hide()
		grab_focus_once = true
