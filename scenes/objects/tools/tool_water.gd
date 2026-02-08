extends StaticBody2D

signal water_found

func _on_area_2d_body_entered(body: Node2D) -> void:
	water_found.emit()
	print('Pick up water')
	body.new_tool = true
	body.found_tool = Enum.Tool.WATER
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
