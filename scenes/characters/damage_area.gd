extends Area2D


#Collision layer/mask is only set to layer 2 for the player

func _on_body_entered(body: Node2D) -> void:
	body.in_enemy_range = true
	if body.taking_damage == false:
		body.taking_damage = true
		print('Warning! You are taking Damage!')
		body.health -= 1
		await get_tree().create_timer(0.5).timeout
		body.taking_damage = false

func _on_body_exited(body: Node2D) -> void:
	body.in_enemy_range = false
