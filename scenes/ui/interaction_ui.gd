extends Control

@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MessageLabel
@onready var timer: Timer = $Timer
@onready var no_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton
@onready var continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ContinueButton
@onready var yes_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/YesButton

signal yes
signal no
signal ok

var grab_focus_once : bool = false

func update_message(message : String):
	message_label.text = message

func _on_yes_button_pressed() -> void:
	yes.emit()

func _on_no_button_pressed() -> void:
	no.emit()
	

func _on_continue_button_pressed() -> void:
	ok.emit()
	continue_button.hide()
	yes_button.show()
	no_button.show()


func add_continue_button():
	yes_button.hide()
	no_button.hide()
	continue_button.show()
	continue_button.grab_focus()

func select():
	#Engine.time_scale = 0
	if grab_focus_once == false:
		no_button.grab_focus()
		continue_button.hide()
		grab_focus_once = true
