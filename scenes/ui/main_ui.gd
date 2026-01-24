extends Control

@onready var day_time_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/DayTimeLabel
@onready var day_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/DayLabel
@onready var message_label: Label = $MarginContainer2/HBoxContainer/PanelContainer/MessageLabel

func _ready() -> void:
	message_label.hide()


func update_time(day_time: int, night_time: int, timer:bool):
	if timer == true:
		day_time_label.text = "Day Time Remaining: " + str(day_time)
		
	else:
		day_time_label.text = "Night Time Remaining: " + str(night_time)
		var message : String = "Survive the Night!"
		update_message(message)

	
func update_day(day: int):
	day_label.text = "Day: " + str(day)

func update_health(max_health: int, health: int):
	$MarginContainer/VBoxContainer/HBoxContainer2/PanelContainer/HBoxContainer/VBoxContainer/HealthBar.max_value = max_health
	$MarginContainer/VBoxContainer/HBoxContainer2/PanelContainer/HBoxContainer/VBoxContainer/HealthBar.value = health

func update_message(message : String):
	$MessageTimer.start()
	message_label.text = message
	message_label.show()

func _on_message_timer_timeout() -> void:
	message_label.hide()
