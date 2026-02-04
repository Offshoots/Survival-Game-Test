extends Control

@onready var message_label: Label = $PanelContainer/MarginContainer/VBoxContainer/MessageLabel
@onready var timer: Timer = $Timer
@onready var no_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NoButton

var grab_focus_once : bool = false

func update_message(message : String):
	message_label.text = message

func _on_yes_button_pressed() -> void:
	#Engine.time_scale = 1
	timer.start()

func _on_no_button_pressed() -> void:
	return

func _on_timer_timeout() -> void:
	print("You win")
	#get_tree().change_scene_to_file("res://scenes/Cutscenes/cutscene.tscn")

func select():
	#Engine.time_scale = 0
	if grab_focus_once == false:
		no_button.grab_focus()
		grab_focus_once = true
