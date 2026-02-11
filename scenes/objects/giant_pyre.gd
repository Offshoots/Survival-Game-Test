extends StaticBody2D

signal entered_giant_pyre
signal exited_pyre_doorway
signal entered_dungeon

var Giant_Pyre_0 : String = "res://graphics/objects/Giant_Pyre.png"
var Giant_Pyre_1 : String = "res://graphics/objects/Giant_Pyre1.png"
var Giant_Pyre_2 : String = "res://graphics/objects/Giant_Pyre2.png"
var Giant_Pyre_3 : String = "res://graphics/objects/Giant_Pyre3.png"
var Giant_Pyre_4 : String = "res://graphics/objects/Giant_Pyre4.png"

var hits_to_crack_1 = 1
var hits_to_crack_2 = 4
var hits_to_crack_3 = 8
var hits_to_crack_4 = 12

func _on_area_2d_body_entered(_body: Node2D) -> void:
	entered_giant_pyre.emit()

var stone : bool = false
var max_health = 1000
var health = max_health:
	set(value):
		health = value
		if health == max_health-hits_to_crack_1:
			$FlashSprite2D.texture = load(Giant_Pyre_1)
		if health == max_health-hits_to_crack_2:
			$FlashSprite2D.texture = load(Giant_Pyre_2)
		if health == max_health-hits_to_crack_3:
			$FlashSprite2D.texture = load(Giant_Pyre_3)
		if health == max_health-hits_to_crack_4:
			$FlashSprite2D.texture = load(Giant_Pyre_4)
			$CollisionShape2D.queue_free()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(10,10)
			$DungeonArea2D2.show()
			$DungeonArea2D2/CollisionShape2D.shape = shape
			$DungeonArea2D2/CollisionShape2D.position.y = 10
		if health == 0:
			#Changed to when health == 0 so that the below code is only executed once
			$FlashSprite2D.hide()
			$AnimatedSprite2D.hide()
			$PointLight2D.hide()
			$PanelContainer.hide()
			$CollisionPolygon2D.queue_free()


#Pyre will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Pyre node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.PICKAXE:
		health -= 1
		stone = true
		Scores.stones_mined_from_great_pyre
		if health > (max_health - hits_to_crack_4):
			$FlashSprite2D.flash()


func _on_dungeon_area_2d_2_body_entered(_body: Node2D) -> void:
	entered_dungeon.emit()


func _on_exited_doorway_area_2d_body_entered(body: Node2D) -> void:
	exited_pyre_doorway.emit()

func show_exit_area():
	$ExitedDoorwayArea2D.show()

func hide_exit_area():
	$ExitedDoorwayArea2D.hide()

func disable_collision_polygon():
	$CollisionPolygon2D.disabled  = true

func enable_collision_polygon():
	$CollisionPolygon2D.disabled  = false
