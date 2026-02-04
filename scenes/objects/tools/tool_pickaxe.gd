extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	print('Pick up Pickaxe')
	body.new_tool = true
	body.found_tool = Enum.Tool.PICKAXE
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
