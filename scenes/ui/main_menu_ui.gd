extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var margin_container: MarginContainer = $MarginContainer
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var margin_container_2: MarginContainer = $MarginContainer2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


@onready var character_texture: TextureRect = $MarginContainer/HBoxContainer/CharacterContainer/HBoxContainer/VBoxContainer/CharacterTexture
@onready var start_button: Button = $MarginContainer/HBoxContainer/ButtonContainer/VBoxContainer/StartButton
@onready var viking_button: Button = $MarginContainer/HBoxContainer/CharacterContainer/HBoxContainer/VBoxContainer/HBoxContainer/VikingButton
@onready var girl_button: Button = $MarginContainer/HBoxContainer/CharacterContainer/HBoxContainer/VBoxContainer/HBoxContainer/GirlButton
@onready var boy_button: Button = $MarginContainer/HBoxContainer/CharacterContainer/HBoxContainer/VBoxContainer/HBoxContainer/BoyButton



@onready var story_container: MarginContainer = $MarginContainer/HBoxContainer/StoryContainer
@onready var video_container: MarginContainer = $MarginContainer/HBoxContainer/VideoContainer
@onready var character_container: MarginContainer = $MarginContainer/HBoxContainer/CharacterContainer
@onready var button_container: MarginContainer = $MarginContainer/HBoxContainer/ButtonContainer
@onready var settings_container: MarginContainer = $SettingsContainer
@onready var game_rules: Button = $SettingsContainer/VBoxContainer/GameRules
@onready var return_button: Button = $SettingsContainer/VBoxContainer/ReturnButton
@onready var control_texture: TextureRect = $ControlTexture
@onready var wood_container: MarginContainer = $SettingsContainer/WoodContainer



var first_play : bool = true

func _ready() -> void:
	video_stream_player.hide()
	character_container.hide()
	start_button.grab_focus()
	settings_container.hide()
	Scores.player_selected = Enum.Style.VIKING
	control_texture.hide()


func _on_options_button_pressed() -> void:
	$AnimatedSprite2D.hide()
	character_container.show()
	viking_button.grab_focus()
	story_container.hide()
	video_container.hide()
	button_container.hide()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_settings_button_pressed() -> void:
	wood_container.hide()
	game_rules.show()
	return_button.grab_focus()
	animated_sprite_2d.hide()
	margin_container.hide()
	settings_container.show()
	control_texture.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()



func _on_viking_button_pressed() -> void:
	character_texture.texture = preload("res://graphics/characters/Viking.png")
	Scores.player_selected = Enum.Style.VIKING
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_girl_button_pressed() -> void:
	character_texture.texture = preload("res://graphics/characters/girl.png")
	Scores.player_selected = Enum.Style.WESLEY
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_boy_button_pressed() -> void:
	character_texture.texture = preload("res://graphics/characters/boy.png")
	Scores.player_selected = Enum.Style.BASIC
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_viking_button_focus_entered() -> void:
	print("focus viking")
	character_texture.texture = preload("res://graphics/characters/Viking.png")

func _on_girl_button_focus_entered() -> void:
	print("focus girl")
	character_texture.texture = load("res://graphics/characters/girl.png")


func _on_boy_button_focus_entered() -> void:
	character_texture.texture = load("res://graphics/characters/boy.png")


func _on_return_button_pressed() -> void:
	wood_container.hide()
	control_texture.hide()
	start_button.grab_focus()
	animated_sprite_2d.show()
	margin_container.show()
	settings_container.hide()
	video_stream_player.hide()
	video_stream_player.stop()
	audio_stream_player_2d.play()
	video_stream_player.stream = preload("res://videos/Startin Rules 2.ogv")


func _on_video_stream_player_finished() -> void:
	if first_play == true:
		video_stream_player.stream = preload("res://videos/Rules Ending 2.ogv")
		video_stream_player.play()
		first_play = false
		

func _on_game_rules_pressed() -> void:
	wood_container.show()
	return_button.grab_focus()
	first_play = true
	control_texture.hide()
	game_rules.hide()
	video_stream_player.show()
	video_stream_player.play()
	audio_stream_player_2d.stop()
	
