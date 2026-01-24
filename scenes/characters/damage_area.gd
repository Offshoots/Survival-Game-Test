extends Area2D

@onready var timer: Timer = $Timer
var damage : bool = false

func _on_body_entered(body: Node2D) -> void:
	if damage == false:
		timer.start()
		body.health -= 1
		body.damage = true
		damage = true
		

func _on_timer_timeout() -> void:
	print('Warning! You are taking Damage!')
	damage = false
