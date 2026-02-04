extends Control

@onready var main_menu_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/MainMenuButton
@onready var quit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/QuitButton


func _ready() -> void:
	main_menu_button.grab_focus()

func _on_main_menu_button_pressed() -> void:
	AudioManager.music_player.stop()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
