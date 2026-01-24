extends Control

@onready var fade_transition: ColorRect = $FadeTransition

func _ready() -> void:
	fade_transition.modulate.a = 1.0
	fade_in()
	#Engine.time_scale = 1.0

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")


func _on_restart_button_pressed() -> void:
	pass


func fade_in():
	var tween := create_tween()
	tween.tween_property(fade_transition, "modulate:a", 0.0 , 1.0)
	await tween.finished
