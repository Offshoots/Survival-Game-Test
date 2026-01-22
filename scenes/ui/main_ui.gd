extends Control

@onready var day_time_label: Label = $MarginContainer/HBoxContainer/PanelContainer/DayTimeLabel

func update_time(time: int):
	day_time_label.text = "Time Remaining: " + str(time)
	
