extends Control


@onready var margin_container: MarginContainer = $MarginContainer
@onready var main_video: VideoStreamPlayer = $MainVideo
@onready var fade_transition: ColorRect = $FadeTransition
@onready var main_video_2: VideoStreamPlayer = $MainVideo2
@onready var video_stream_player: VideoStreamPlayer = $SubViewportContainer/SubViewport/VideoStreamPlayer
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
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

var warned_1 : bool = false
var warned_2 : bool = false
var first_play : bool = true
var time_remaining = 3

func _ready() -> void:
	sub_viewport_container.hide()
	video_stream_player.hide()
	character_container.hide()
	start_button.grab_focus()
	settings_container.hide()
	Scores.player_selected = Enum.Style.VIKING
	control_texture.hide()
	main_video.play()
	main_video.volume_db = -20.0
	fade_transition.color.a = 1.0
	fade_in()
	fade_in_audio(main_video)

func _physics_process(_delta: float) -> void:
	if main_video.is_playing() and !warned_1:
		var length = main_video.get_stream_length()
		var pos = main_video.stream_position
		var time = time_remaining
		if length - pos <= time:
			warned_1 = true
			fade_out_audio(main_video)
			main_video_2.play()
			fade_VideoA_to_VideoB(main_video, main_video_2)
			main_video_2.volume_db = -20.0
			fade_in_audio(main_video_2)
	if main_video_2.is_playing() and !warned_2:
		var length = main_video_2.get_stream_length()
		var pos = main_video_2.stream_position
		var time = time_remaining
		if length - pos <= time:
			warned_2 = true
			#print("near the track end!")
			fade_out_audio(main_video_2)
			main_video.play()
			fade_VideoA_to_VideoB(main_video_2,main_video)
			main_video.volume_db = -20.0
			fade_in_audio(main_video)


func _on_options_button_pressed() -> void:
	$MainVideo.hide()
	character_container.show()
	viking_button.grab_focus()
	story_container.hide()
	video_container.hide()
	button_container.hide()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func _on_settings_button_pressed() -> void:
	main_video.hide()
	main_video_2.hide()
	wood_container.hide()
	game_rules.show()
	return_button.grab_focus()
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
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")
	#main_video.show()
	#main_video_2.hide()
	#wood_container.hide()
	#control_texture.hide()
	#start_button.grab_focus()
	#margin_container.show()
	#settings_container.hide()
	#video_stream_player.hide()
	#video_stream_player.stop()
	##audio_stream_player_2d.play()
	#video_stream_player.stream = preload("res://videos/Startin Rules 2.ogv")


func _on_video_stream_player_finished() -> void:
	if first_play == true:
		video_stream_player.stream = preload("res://videos/Rules Ending 2.ogv")
		video_stream_player.play()
		first_play = false
		

func _on_game_rules_pressed() -> void:
	sub_viewport_container.show()
	main_video.stop()
	main_video_2.stop()
	wood_container.show()
	return_button.grab_focus()
	first_play = true
	control_texture.hide() 
	game_rules.hide()
	video_stream_player.show()
	video_stream_player.play()
	audio_stream_player_2d.stop()

func fade_in():
	var tween := create_tween()
	tween.tween_property(fade_transition, "color:a", 0.0 , 3)
	await tween.finished
	#await get_tree().create_timer(1.5).timeout

func fade_VideoA_to_VideoB(video_A: VideoStreamPlayer, video_B: VideoStreamPlayer):
	var tween := create_tween()
	tween.tween_property(video_A, "modulate:a", 0.01 , time_remaining)
	tween.parallel().tween_property(video_B, "modulate:a", 1 , time_remaining * 0.5)
	await tween.finished
	#await get_tree().create_timer(1.5).timeout


func fade_out():
	var tween := create_tween()
	tween.tween_property(fade_transition, "color:a", 1.0 , 1)
	await tween.finished
	#await get_tree().create_timer(1.5).timeout

func fade_in_audio(player: VideoStreamPlayer):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -10.0, 1)

func fade_out_audio(player: VideoStreamPlayer):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -20.0, 1)


func _on_main_video_finished() -> void:
	warned_1 = false

func _on_main_video_2_finished() -> void:
	warned_2 = false
