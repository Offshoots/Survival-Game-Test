extends StaticBody2D

signal toy_found

func _on_area_2d_body_entered(_body: Node2D) -> void:
	toy_found.emit()
	print('Pick up Toy')
	Scores.motivation_boost += 10
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
