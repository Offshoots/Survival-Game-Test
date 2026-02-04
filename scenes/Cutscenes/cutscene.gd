extends Control

@onready var video: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	video.play()
