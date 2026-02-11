extends StaticBody2D

signal approach_statue

func _on_area_2d_body_entered(_body: Node2D) -> void:
	approach_statue.emit()
