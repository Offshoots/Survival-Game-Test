extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/StartButton
@onready var viking_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/VikingButton
@onready var girl_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/GirlButton
@onready var boy_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/BoyButton
@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/TextureRect

var viking = preload("res://graphics/characters/Viking.png")

func _ready() -> void:
	start_button.grab_focus()
	$MarginContainer/HBoxContainer/MarginContainer2.hide()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_options_button_pressed() -> void:
	$AnimatedSprite2D.hide()
	viking_button.grab_focus()
	$MarginContainer/HBoxContainer/MarginContainer.hide()
	$MarginContainer/HBoxContainer/MarginContainer2.show()
	$MarginContainer/HBoxContainer/Spacer2.hide()
	$MarginContainer/HBoxContainer/Spacer.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()



func _on_viking_button_pressed() -> void:
	texture_rect.texture = preload("res://graphics/characters/Viking.png")
	Scores.player_selected = Enum.Style.VIKING
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_girl_button_pressed() -> void:
	texture_rect.texture = preload("res://graphics/characters/girl.png")
	Scores.player_selected = Enum.Style.WESLEY
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_boy_button_pressed() -> void:
	texture_rect.texture = preload("res://graphics/characters/boy.png")
	Scores.player_selected = Enum.Style.BASIC
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_viking_button_focus_entered() -> void:
	print("focus viking")
	texture_rect.texture = viking

func _on_girl_button_focus_entered() -> void:
	print("focus girl")
	texture_rect.texture = load("res://graphics/characters/girl.png")


func _on_boy_button_focus_entered() -> void:
	texture_rect.texture = load("res://graphics/characters/boy.png")
