extends StaticBody2D

var coord: Vector2i

var stone : bool = false

signal entered_pyre(body:Node2D)

var health := 4:
	set(value):
		health = value
		if health == 0:
			#Changed to when health == 0 so that the below code is only executed once
			$FlashSprite2D.hide()
			$AnimatedSprite2D.hide()
			$PointLight2D.hide()
			$PanelContainer.hide()
			$CollisionShape2D.queue_free()
			stone = true
		else:
			stone = false

func _process(_delta: float) -> void:
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
	#$Sprite2D.show()
	$FlashSprite2D.show()
	$AnimatedSprite2D.hide()
	$PointLight2D.hide()
	$Area2D.queue_free()

#Pyre will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Pyre node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.PICKAXE:
		$FlashSprite2D.flash()
		health -= 1
