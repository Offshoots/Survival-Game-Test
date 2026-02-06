extends StaticBody2D

signal smash

#Use Bool for item pickup. If the Item is present for the event that it would be collected, then the bool is true.
#The item will be added to the inventory via the Level scene into the ItemContainerUI, after assisinging the approiate enum to get the correct icon and properties.
var stone : bool = false

var health := 4:
	set(value):
		health = value
		if health == 0:
			#Changed to when health == 0 so that the below code is only executed once
			$FlashSprite2D.hide()
			$CollisionShape2D.queue_free()
			Scores.score_rocks_smashed += 1
			stone = true
		else:
			stone = false


func _ready() -> void:
	#$FlashSprite2D.frame = [0,1].pick_random()
	pass

#Tree will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Tree node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.PICKAXE:
		$FlashSprite2D.flash()
		health -= 1

func reset():
	if health > 0:
		health = 5

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		smash.emit()
		print('smash')
