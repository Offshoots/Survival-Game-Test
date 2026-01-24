extends StaticBody2D



const apple_texture = preload("res://graphics/plants/apple.png")

#Use Bool for item pickup. If the Item is present for the event that it would be collected, then the bool is true.
#The item will be added to the inventory via the Level scene into the ItemContainerUI, after assisinging the approiate enum to get the correct icon and properties.
var apples : bool = false
var wood : bool = false
var health := 4:
	set(value):
		health = value
		if health == 0:
			#Changed to when health == 0 so that the below code is only executed once
			$FlashSprite2D.hide()
			$Stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			$CollisionShape2D.shape = shape
			$CollisionShape2D.position.y = 6
			wood = true
		else:
			wood = false
		

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
		apples = true
		$Apples.get_children().pick_random().queue_free()
	else:
		apples = false


func reset():
	if health > 0:
		#Restore the tree's health
		health = 5
		
		#This version would clear all the apples and then create a random number of apples up to 3:
		#for apple in $Apples.get_children():
			#apple.queue_free()
		#create_apples(randi_range(0,3))
		
		#This version will check if there are less then 3 apples and add 0 or 1.
		if $Apples.get_child_count() < 3:
			create_apples(randi_range(0,1))
	
	
