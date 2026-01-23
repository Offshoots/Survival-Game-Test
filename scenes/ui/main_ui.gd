extends Control

@onready var day_time_label: Label = $MarginContainer/HBoxContainer/PanelContainer/DayTimeLabel
@onready var day_label: Label = $MarginContainer/HBoxContainer/PanelContainer2/DayLabel
@onready var message_label: Label = $MarginContainer2/HBoxContainer/PanelContainer/MessageLabel



func update_time(day_time: int, night_time: int, timer:bool):
	if timer == true:
		day_time_label.text = "Day Time Remaining: " + str(day_time)
		message_label.hide()
	else:
		day_time_label.text = "Night Time Remaining: " + str(night_time)
		message_label.show()
	
func update_day(day: int):
	day_label.text = "Day: " + str(day)
	
