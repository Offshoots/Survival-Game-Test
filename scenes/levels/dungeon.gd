extends Node2D

@onready var statue: StaticBody2D = $Statue

signal exit_dungeon 
var inside_dungeon : bool = false


func _on_statue_approach_statue() -> void:
	print("Whoooa!")


func _on_entered_area_2d_body_entered(_body: Node2D) -> void:
	inside_dungeon = true


func _on_exit_area_2d_body_entered(_body: Node2D) -> void:
	if inside_dungeon == true:
		exit_dungeon.emit()
