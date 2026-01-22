extends Node2D

var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/ui/plant_info.tscn")
var item_info_scene = preload("res://scenes/ui/item_info.tscn")
var box_scene = preload("res://scenes/objects/box.tscn")
var tree_scene = preload("res://scenes/objects/tree.tscn")
var rock_scene = preload("res://scenes/objects/rock.tscn")
var enemy_scene = preload("res://scenes/characters/blob.tscn")
var used_cells: Array[Vector2i]
var placement_pos : Vector2

var apple: int
var wood: int
var stone: int
var tomato: int
var corn: int
var pumpkin: int
var wheat: int

@onready var player = $Objects/Player
#@onready var tree = $Objects/Tree
@onready var inv = $Overlay/CanvasLayer/InventoryContainer
@export var daytime_color: Gradient
@onready var main_ui: Control = $Overlay/CanvasLayer/MainUI


func _ready() -> void:
	var rand_tree = randi_range(30,50)
	var rand_rock = randi_range(6,8)
	var rand_enemy = randi_range(2,3)
	spawn_trees(rand_tree)
	spawn_rocks(rand_rock)
	spawn_enemies(rand_enemy)
	

#This physic function was put in the level script just for active frame debuging. 
#However this could be a very cool "Cursor" or "Aim/Reticle" in a different game.
func _physics_process(_delta: float) -> void:
	placement_pos = player.position + player.last_direction * 16 + Vector2(0,4)
	var pos = placement_pos
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	$Layers/DebugLayer.clear()
	$Layers/DebugLayer.set_cell(grid_coord, 0, Vector2i(0,0))

func _process(_delta: float) -> void:
	#Create a ratio of how much of the day has passed from 0 to 1.
	var daytime_point = 1 - ($Timers/DayTimer.time_left / $Timers/DayTimer.wait_time)
	var color = daytime_color.sample(daytime_point)
	var time = $Timers/DayTimer.time_left
	main_ui.update_time(time)
	#print(daytime_point)
	$Overlay/DayTimeColor.color = color
	if Input.is_action_just_pressed("day_change"):
		day_restart()
		#Survival Mode will require food to be consumed each day. Subtract 1 apple each day:
		#need to remove an apple from the player.inventory array
		remove_inventory(Enum.Item.APPLE)
	
	if Input.is_action_just_pressed("inventory"):
		$Overlay/CanvasLayer/InventoryContainer.visible = not $Overlay/CanvasLayer/InventoryContainer.visible
	
	if Input.is_action_just_pressed("build"):
		#Can use enums to select different builds, but for now build a box
		if player.inventory.count(Enum.Item.WOOD) >= 1:
			var craft = Enum.Craft.BOX
			build(craft, placement_pos)
			remove_inventory(Enum.Item.WOOD)
	
	#Monitor the player for any items collected via "Body_entered" interactions with Area2D in other scenes.
	if player.new_item == true:
		var item_dropped = player.current_inventory
		add_inventory(item_dropped)
		player.new_item = false

#Populate trees in random position via markers on the map (called in ready function)
func spawn_trees(num: int):
	var tree_markers = $Objects/TreeSpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = tree_markers.pop_at(randf_range(0, tree_markers.size()-1))
		var new_tree = tree_scene.instantiate()
		$Objects.add_child(new_tree)
		new_tree.position = pos_marker.position

func spawn_rocks(num: int):
	var rock_markers = $Objects/RockSpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = rock_markers.pop_at(randf_range(0, rock_markers.size()-1))
		var new_rock = rock_scene.instantiate()
		$Objects.add_child(new_rock)
		new_rock.position = pos_marker.position

func spawn_enemies(num: int):
	var enemy_markers = $Objects/EnemySpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = enemy_markers.pop_at(randf_range(0, enemy_markers.size()-1))
		var new_enemy = enemy_scene.instantiate()
		$Objects.add_child(new_enemy)
		new_enemy.position = pos_marker.position

#Build when 'B' Input map action is pressed (called in process function)
func build(craft: Enum.Craft, pos: Vector2):
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	if grid_coord not in used_cells:
		#Need to create a new "Box" scene with collision shape and sprite
		#preload and Instantiate that box scene
		var box = box_scene.instantiate()
		#add_child(box)
		box.setup(grid_coord, $Objects)
		used_cells.append(grid_coord)
		#Test out removing the layer with navigation and placing a tile without navigation.
		$Layers/GrassLayer.erase_cell(grid_coord)
		$Layers/SoilLayer.set_cells_terrain_connect([grid_coord], 0, 0)
		print(grid_coord)
		#Test removing the grid cells up, down, left, and right of the box
		#$Layers/GrassLayer.erase_cell(Vector2i(grid_coord.x - 1, grid_coord.y))
		#$Layers/GrassLayer.erase_cell(Vector2i(grid_coord.x + 1, grid_coord.y))
		#$Layers/GrassLayer.erase_cell(Vector2i(grid_coord.x, grid_coord.y - 1))
		#$Layers/GrassLayer.erase_cell(Vector2i(grid_coord.x, grid_coord.y + 1))
		
		#Test painting a new property layer for tileset that will have a box place on it
		#I have found some success with removing the corners from the navigation tiles

#This will toggle the plant info bar on/off by pressing the diagnose button "N"
func _on_player_diagnose() -> void:
	$Overlay/CanvasLayer/PlantInfoContainer.visible = not $Overlay/CanvasLayer/PlantInfoContainer.visible

#Tool use comes from the player scene script. Actions of tool use are completed in the Level scene and script.
func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = $Layers/SoilLayer.get_cell_tile_data(grid_coord) as TileData
	match tool:
		Enum.Tool.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData
			#"If cell" checks if is a valid grass tile (or null) first. The "and" statement then confirmed if it is a a valid farmable tile.
			if cell and cell.get_custom_data('farmable') == true:
				$Layers/SoilLayer.set_cells_terrain_connect([grid_coord], 0, 0)
		Enum.Tool.WATER:
			#This is my version of the watering tool soil code. Clear Code says it works but is "Overkill"
			#$Layers/SoilWaterLayer.set_cells_terrain_connect([grid_coord], 0, 0)
			if has_soil:
				$Layers/SoilWaterLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		Enum.Tool.FISH:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData
			if !cell:
				print("Water")
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant_res = PlantResource.new()
				#Setup function for the plant data (in plant resource)
				plant_res.setup(player.current_seed)
				var plant = plant_scene.instantiate()
				#Setup function for the plant scene
				plant.setup(grid_coord, $Objects, plant_res, plant_death)
				used_cells.append(grid_coord)
				
				#print(used_cells)
				#After Identifying that the used_cell is not cleared when a plant dies due to decay, because the decay function is in the plant_res script. 
				#The "death_coord" function passes the grid coord of the plant and the plant_death function that will be connected
				plant_res.death_coord(grid_coord, plant_death)
				
				var plant_info = plant_info_scene.instantiate()
				plant_info.setup(plant_res)
				$Overlay/CanvasLayer/PlantInfoContainer.add(plant_info)
		Enum.Tool.PICKAXE:
			#For now group for Rock has been changed from 'Objects' to new group 'Rock'.
			for object in get_tree().get_nodes_in_group('Rock'):
				if object.position.distance_to(pos)< 20:
					object.hit(tool)
					if object.stone:
						var item_drop = Enum.Item.STONE
						player.inventory.append(item_drop)
						add_inventory(item_drop)
		Enum.Tool.SWORD:
			#For now group for blob has been changed from 'Objects' to new group 'Enemy'.
			for object in get_tree().get_nodes_in_group('Enemy'):
				if object.position.distance_to(pos)< 20:
					object.hit(tool)
					if object.gold:
						var item_drop = Enum.Item.GOLD
						player.inventory.append(item_drop)
						add_inventory(item_drop)
		Enum.Tool.AXE:
			#Currently all trees are in group 'Objects'.
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos)< 20:
					object.hit(tool)
					if object.apples:
						var item_drop = Enum.Item.APPLE
						player.inventory.append(item_drop)
						add_inventory(item_drop)
					if object.wood:
						var item_drop = Enum.Item.WOOD
						player.inventory.append(item_drop)
						add_inventory(item_drop)

#region Inventory Add, Remove, and Update
#Use Bool for item pickup inside the correct scenes. If the Item is present for the event that it would be collected, then the bool is true.
#The item will be added to the inventory via the Level scene into the ItemContainerUI, after assisinging the approiate enum to get the correct icon and properties.
func add_item(item_drop : Enum.Item):
	var item_res = ItemResource.new()
	item_res.setup(item_drop)
	var item_info = item_info_scene.instantiate()
	item_info.setup(item_res)
	$Overlay/CanvasLayer/InventoryContainer.add(item_info)

func add_inventory(item_added : Enum.Item):
	#Created simplified code for any item (no need to check which item it is anymore):
	if player.inventory.count(item_added) == 1:
		add_item(item_added)
	update_invetory(item_added)

#Update inventory function take the Enum.Item being added or removed and updates it
func update_invetory(item_updated : Enum.Item):
	#create new var count for the number of that item found in the player.inventory array, and pass that information into the "update_all" function
	var count = player.inventory.count(item_updated)
	$Overlay/CanvasLayer/InventoryContainer.update_all(count, item_updated)

func remove_inventory(item_removed: Enum.Item):
	#Remove one matching item from the inventory using "erase"
	player.inventory.erase(item_removed)
	print(player.inventory)
	update_invetory(item_removed)
#endregion


#region Day Restart and Level Reset
func day_restart():
	var tween = create_tween()
	#adjust the shader parameter that creates the circle transistion
	tween.tween_property($Overlay/CanvasLayer/DayTransitionLayer.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property($Overlay/CanvasLayer/DayTransitionLayer.material, "shader_parameter/progress", 0.0, 1.0)

func level_reset():
	for plant in get_tree().get_nodes_in_group('Plants'):
		#If there is water on the tile, then plant function grow can be completed
		plant.grow(plant.coord in $Layers/SoilWaterLayer.get_used_cells())
	$Overlay/CanvasLayer/PlantInfoContainer.update_all()
	$Layers/SoilWaterLayer.clear()
	$Timers/DayTimer.start()
	#This code will search for all object (Trees or other) that have a reset function and will execute the reset.
	for object in get_tree().get_nodes_in_group('Objects'):
		if 'reset' in object:
			object.reset()
#endregion

#After a plany dies, delete cells used by that plant from the used_cells array
func plant_death(coord: Vector2i):
	used_cells.erase(coord)
