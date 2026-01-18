extends StaticBody2D

const apple_texture = preload("res://graphics/plants/apple.png")
var health := 4:
	set(value):
		health = value
		print(value)
		if health <= 0:
			$FlashSprite2D.hide()
			$Stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			$CollisionShape2D.shape = shape
			$CollisionShape2D.position.y = 6
		

#To Do list:
#Tree should flash when hit, we will add a shader
#Apples disappear (or drop when hit)
#Tree is Killable
#Want to add: Tree drops consumables (apples/wood)


func _ready() -> void:
	$FlashSprite2D.frame = [0,1].pick_random()
	create_apples(randi_range(0,3))

#Tree will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Tree node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.AXE:
		$FlashSprite2D.flash()
		get_apples()
		health -= 1

#Populate apples in random position via markers on the Tree
func create_apples(num: int):
	var apple_markers = $AppleSpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = apple_markers.pop_at(randf_range(0, apple_markers.size()-1))
		var sprite = Sprite2D.new()
		sprite.texture = apple_texture
		$Apples.add_child(sprite)
		sprite.position = pos_marker.position

#Remove Apples when the tree is hit
func get_apples():
	#if $Apples.get_children exists (if there are any apples on the tree)
	if $Apples.get_children():
		$Apples.get_children().pick_random().queue_free()
		print('get apple')

func reset():
	if health > 0:
		for apple in $Apples.get_children():
			apple.queue_free()
		create_apples(randi_range(0,3))
		health = 5
	
