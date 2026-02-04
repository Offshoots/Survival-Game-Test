extends Control

@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MessageLabel
@onready var timer: Timer = $Timer
@onready var no_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton

signal yes
signal no

var grab_focus_once : bool = false

func update_message(message : String):
	message_label.text = message

func _on_yes_button_pressed() -> void:
	yes.emit()

func _on_no_button_pressed() -> void:
	no.emit()
	

func select():
	#Engine.time_scale = 0
	if grab_focus_once == false:
		no_button.grab_focus()
		grab_focus_once = true
