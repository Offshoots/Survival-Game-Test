extends StaticBody2D

var coord: Vector2i

signal entered_pyre(body:Node2D)

func _process(delta: float) -> void:
	update_fuel($FuelTimer.wait_time, $FuelTimer.time_left)


func _on_area_2d_body_entered(body: Node2D) -> void:
	entered_pyre.emit(body)


func setup(grid_coord: Vector2i, parent: Node2D):
	position = grid_coord * Data.TILE_SIZE + Vector2i(8 , 5)
	parent.add_child(self)
	coord = grid_coord
	$FuelTimer.start()
	update_fuel($FuelTimer.wait_time, $FuelTimer.wait_time)
	#res = new_res
	#$Sprite2D.texture = res.texture

func update_fuel(max_fuel: int, fuel: int):
	$PanelContainer/TextureProgressBar.max_value = max_fuel
	$PanelContainer/TextureProgressBar.value = fuel


#When the fuel runs out, make the light go out
func _on_fuel_timer_timeout() -> void:
	$PointLight2D.hide()
	$Area2D.hide()
