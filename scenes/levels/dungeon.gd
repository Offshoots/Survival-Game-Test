extends Node2D

signal exit_dungeon 
signal approach_statue
var inside_dungeon : bool = false


func _on_entered_area_2d_body_entered(_body: Node2D) -> void:
	inside_dungeon = true

func _on_exit_area_2d_body_entered(_body: Node2D) -> void:
	if inside_dungeon == true:
		exit_dungeon.emit()

func _on_statue_area_2d_body_entered(body: Node2D) -> void:
	approach_statue.emit()

func disable_layers():
	$WaterLayer.enabled = false
	$GrassLayer.enabled = false
	
func enable_layers():
	$WaterLayer.enabled = true
	$GrassLayer.enabled = true
	
