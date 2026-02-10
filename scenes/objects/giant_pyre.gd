extends StaticBody2D

signal entered_giant_pyre

var Giant_Pyre_0 : String = "res://graphics/objects/Giant_Pyre.png"
var Giant_Pyre_1 : String = "res://graphics/objects/Giant_Pyre1.png"
var Giant_Pyre_2 : String = "res://graphics/objects/Giant_Pyre2.png"
var Giant_Pyre_3 : String = "res://graphics/objects/Giant_Pyre3.png"
var Giant_Pyre_4 : String = "res://graphics/objects/Giant_Pyre4.png"


func _on_area_2d_body_entered(_body: Node2D) -> void:
	entered_giant_pyre.emit()

var stone : bool = false
var max_health = 1000
var health := max_he:
	set(value):
		health = value
		if health == max_health
		if health == 995:
			#Changed to when health == 0 so that the below code is only executed once
			$FlashSprite2D.hide()
			$AnimatedSprite2D.hide()
			$PointLight2D.hide()
			$PanelContainer.hide()
			$CollisionShape2D.queue_free()
			stone = true
		else:
			stone = false
			
			

#Pyre will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Pyre node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.PICKAXE:
		$FlashSprite2D.flash()
		health -= 1
		Scores.stones_mined_from_great_pyre
