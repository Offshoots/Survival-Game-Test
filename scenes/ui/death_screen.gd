extends Control

@onready var fade_transition: ColorRect = $FadeTransition
var music = AudioManager.music_player
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var main_menu_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/MainMenuButton
@onready var restart_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/RestartButton
@onready var stats_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/StatsButton
@onready var quit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton

@onready var second_audio_player: AudioStreamPlayer2D = $SecondAudioPlayer

var warned : bool = false

var dual_of_fates = preload("res://audio/DeathTracks/dual of fates - Trim 2.ogg")

var high_ground = preload("res://audio/DeathTracks/I have the high ground - Trim 2.ogg")
var breaking_heart = preload("res://audio/DeathTracks/You're breaking my heart - Trim 2.ogg")
var chosen_one = preload("res://audio/DeathTracks/You were the chosen one - Trim 2.ogg")
var turned_against = preload("res://audio/DeathTracks/You turned her against me 2.ogg")
var failed_you = preload("res://audio/DeathTracks/I have failed you anakin 2.ogg")

var files = [high_ground, breaking_heart, chosen_one, turned_against, failed_you]
var select_audio

func _ready() -> void:
	if Scores.score_days_survived > 2:
		select_audio = files
	else:
		select_audio = [high_ground]
	$ScoreScreen.hide()
	Engine.time_scale = 1.0
	#main_menu_button.hide()
	#restart_button.hide()
	#stats_button.hide()
	#quit_button.hide()
	fade_transition.color.a = 1.0
	audio_stream_player_2d.stream = select_audio.pick_random()
	audio_stream_player_2d.volume_db = -40.0
	audio_stream_player_2d.play()
	fade_in()
	fade_in_audio(audio_stream_player_2d)

func _process(_delta):
	if audio_stream_player_2d.playing and !warned:
		var length = audio_stream_player_2d.stream.get_length()
		var pos = audio_stream_player_2d.get_playback_position()
		var time
		if audio_stream_player_2d.stream == breaking_heart:
			time = 1.5
		else:
			time = 3.0
		if length - pos <= time:
			warned = true
			#print("near the track end!")
			fade_out_audio(audio_stream_player_2d)
			second_audio_player.stream = dual_of_fates
			second_audio_player.volume_db = -10.0
			second_audio_player.play()
			fade_in_audio(second_audio_player)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")

func fade_in():
	var tween := create_tween()
	tween.tween_property(fade_transition, "color:a", 0.0 , 5.0)
	#await tween.finished
	await get_tree().create_timer(1.5).timeout
	$ScoreScreen.show()
	$ScoreScreen.focus_button()
	#main_menu_button.show()
	#restart_button.show()
	#stats_button.show()
	#quit_button.show()
	#restart_button.grab_focus()

func fade_in_audio(player: AudioStreamPlayer2D):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0.0, 1.0)

func fade_out_audio(player: AudioStreamPlayer2D):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80.0, 1.0)


func _on_stats_button_pressed() -> void:
	$MarginContainer.hide()
	$ScoreScreen.show()
	$ScoreScreen.focus_button()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
