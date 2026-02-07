extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var margin_container: MarginContainer = $MarginContainer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var margin_container_2: MarginContainer = $MarginContainer2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var return_button: Button = $MarginContainer2/ReturnButton


@onready var start_button: Button = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/StartButton
@onready var viking_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/VikingButton
@onready var girl_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/GirlButton
@onready var boy_button: Button = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/BoyButton
@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/TextureRect

var viking = preload("res://graphics/characters/Viking.png")

var first_play : bool = true

func _ready() -> void:
	video_stream_player.hide()
	margin_container_2.hide()
	start_button.grab_focus()
	$MarginContainer/HBoxContainer/MarginContainer2.hide()
	Scores.player_selected = Enum.Style.VIKING


func _on_options_button_pressed() -> void:
	$AnimatedSprite2D.hide()
	viking_button.grab_focus()
	$MarginContainer/HBoxContainer/MarginContainer.hide()
	$MarginContainer/HBoxContainer/MarginContainer2.show()
	$MarginContainer/HBoxContainer/Spacer2.hide()
	$MarginContainer/HBoxContainer/Spacer.hide()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_settings_button_pressed() -> void:
	return_button.grab_focus()
	animated_sprite_2d.hide()
	margin_container.hide()
	margin_container_2.show()
	video_stream_player.show()
	video_stream_player.play()
	audio_stream_player_2d.stop()

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


func _on_return_button_pressed() -> void:
	start_button.grab_focus()
	animated_sprite_2d.show()
	margin_container.show()
	margin_container_2.hide()
	video_stream_player.hide()
	video_stream_player.stop()
	audio_stream_player_2d.play()
	first_play = true
	video_stream_player.stream = preload("res://videos/Startin Rules 2.ogv")


func _on_video_stream_player_finished() -> void:
	if first_play == true:
		video_stream_player.stream = preload("res://videos/Rules Ending 2.ogv")
		video_stream_player.play()
		first_play = false
		
