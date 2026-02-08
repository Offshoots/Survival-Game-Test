extends StaticBody2D


var max_ship_health : int = 150

var death : bool = false

signal enter_ship
signal exit_ship

var ship_health : int = 5 :
	set(value):
		ship_health = value
		print(value)
		if ship_health == 0:
			death = true
			Scores.ship_destroyed = true
			print('You Lost you ship!')

func _on_area_2d_body_entered(body: Node2D) -> void:
	enter_ship.emit(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	exit_ship.emit(body)
