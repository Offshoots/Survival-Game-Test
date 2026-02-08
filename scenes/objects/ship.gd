extends StaticBody2D

var ship_health : int = 10
var max_ship_health : int = 12

signal enter_ship
signal exit_ship

func _on_area_2d_body_entered(body: Node2D) -> void:
	enter_ship.emit(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	exit_ship.emit(body)
