extends StaticBody2D

var ship_health : int = 30
var max_ship_health : int = 31

signal enter_ship
signal exit_ship

func _on_area_2d_body_entered(_body: Node2D) -> void:
	enter_ship.emit()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	exit_ship.emit()
