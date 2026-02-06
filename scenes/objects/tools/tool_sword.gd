extends StaticBody2D

signal sword_found

func _on_area_2d_body_entered(body: Node2D) -> void:
	sword_found.emit()
	print('Pick up Sword')
	body.new_tool = true
	body.found_tool = Enum.Tool.SWORD
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
