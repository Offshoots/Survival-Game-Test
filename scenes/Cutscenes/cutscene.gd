extends Control

@onready var video: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer
@onready var video_stream_player_2: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer2

func _ready() -> void:
	$Timer.start()
	AudioManager.music_player.stream = preload("res://audio/YoHo - Trim 2.ogg")
	AudioManager.music_player.play()

func _on_timer_timeout() -> void:
	video.play()


func _on_video_stream_player_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	video_stream_player_2.play()


func _on_video_stream_player_2_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/Ending/score_screen.tscn")
