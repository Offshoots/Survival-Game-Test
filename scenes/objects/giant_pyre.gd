extends StaticBody2D

signal entered_giant_pyre

func _on_area_2d_body_entered(body: Node2D) -> void:
	entered_giant_pyre.emit()
