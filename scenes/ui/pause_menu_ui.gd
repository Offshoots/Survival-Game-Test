extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var panel_container: PanelContainer = $PanelContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var controls_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ControlsButton
@onready var return_button: Button = $MarginContainer/ReturnButton


func _ready() -> void:
	controls_button.grab_focus()
	texture_rect.hide()
	panel_container.show()
	margin_container.hide()

func grab_control_focus():
	controls_button.grab_focus()
	texture_rect.hide()
	panel_container.show()
	margin_container.hide()

func _on_controls_button_pressed() -> void:
	return_button.grab_focus()
	texture_rect.show()
	margin_container.show()
	panel_container.hide()

func _on_main_menu_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")

func _on_return_button_pressed() -> void:
	controls_button.grab_focus()
	texture_rect.hide()
	panel_container.show()
	margin_container.hide()
