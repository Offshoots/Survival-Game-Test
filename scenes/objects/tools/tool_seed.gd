extends StaticBody2D

signal seed_found

func _on_area_2d_body_entered(body: Node2D) -> void:
	seed_found.emit()
	print('Pick up Seed')
	body.new_tool = true
	body.found_tool = Enum.Tool.SEED
	$Area2D.queue_free()
	$Sprite2D.hide()
	$CollisionShape2D.queue_free()
