extends StaticBody2D

signal hoe_found

func _on_area_2d_body_entered(body: Node2D) -> void:
	hoe_found.emit()
	print('Pick up hoe')
	body.new_tool = true
	body.found_tool = Enum.Tool.HOE
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
