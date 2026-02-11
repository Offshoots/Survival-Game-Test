extends Node2D

var cut_scene = preload("res://scenes/Cutscenes/cutscene.tscn")
var interact_scene = preload("res://scenes/ui/interaction_ui.tscn")
var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/ui/plant_info.tscn")
var item_info_scene = preload("res://scenes/ui/item_info.tscn")
var box_scene = preload("res://scenes/objects/box.tscn")
var pyre_scene = preload("res://scenes/objects/pyre.tscn")
var tree_scene = preload("res://scenes/objects/tree.tscn")
var rock_scene = preload("res://scenes/objects/rock.tscn")
var enemy_scene = preload("res://scenes/characters/blob.tscn") 
var seed_scene = preload("res://scenes/objects/tools/tool_seed.tscn")
var hoe_scene = preload("res://scenes/objects/tools/tool_hoe.tscn")
var water_scene = preload("res://scenes/objects/tools/tool_water.tscn")
var toy_scene = preload("res://scenes/objects/rewards/reward_toy.tscn")


var used_cells: Array[Vector2i]
var placement_pos : Vector2

var day: int = 1
var day_timer: bool = true
var giant_pyre_visited : bool = false
var giant_pyre_doorway : bool = false
var ship_visited : bool = false
var axe_visited : bool = false
var extra_wave : bool = false
var repair_ship_message : bool = false
var game_paused : bool = false
var at_ship : bool = false
var no_repair : bool = false

#May not need any of these item variables. I simplified all iventory functions to use Enums
var apple: int
var wood: int
var stone: int
var tomato: int
var corn: int
var pumpkin: int
var wheat: int


@onready var dungeon: Node2D = $Dungeon
@onready var ship: StaticBody2D = $Objects/Ship
@onready var player: CharacterBody2D = $Player 
@onready var inv = $Overlay/CanvasLayer/InventoryContainer
@export var daytime_color: Gradient
@onready var main_ui: Control = $Overlay/CanvasLayer/MainUI
@onready var fade_transition: ColorRect = $Overlay/CanvasLayer/FadeTransition
@onready var interaction_ui: Control = $Overlay/CanvasLayer/InteractionUI
@onready var pause_menu_ui: Control = $Overlay/CanvasLayer/PauseMenuUI

#Test these unstored variabled for the connect signals for rewards


func _ready() -> void:
	dungeon.hide()
	$Dungeon.disable_layers()
	Scores.score_dead = false
	Scores.ship_destroyed = false
	Scores.starved_dead = false
	Scores.victory_chance = false
	#Set all global scores to zero:
	Scores.score_trees_felled = 0
	Scores.score_rocks_smashed = 0
	Scores.score_apples_collected = 0
	Scores.score_apples_eaten = 0
	Scores.score_enemies_slain = 0
	
	Scores.score_gold_collected = 0
	Scores.score_wood_collected = 0
	Scores.score_stone_collected = 0
	Scores.stones_mined_from_great_pyre = 0
	Scores.score_fish_caught = 0
	Scores.score_plants_harvested = 0
	
	Scores.score_enemies_killed_by_daylight = 0
	Scores.score_enemies_killed_by_pyre = 0
	Scores.score_pyres_built = 0
	Scores.motivation_boost = 0
	
	Scores.score_days_survived = 0
	Scores.score_total_time  = 0
	Scores.score_fastest_time_to_repair = 0
	Scores.score_ship_damage_taken = 0
	
	#Get the global variable Scores.player_selected and insert that Enum.Style into the next line to get the correct spritesheet "texture"
	var player_selected = Scores.player_selected
	player.get_node("Sprite2D").texture = Data.PLAYER_SKINS[player_selected]['texture']
	Engine.time_scale = 1.0
	pause_menu_ui.hide()
	var rand_tree = randi_range(50,70)
	var rand_rock = randi_range(8,20)
	spawn_trees(rand_tree)
	spawn_rocks(rand_rock)
	fade_transition.color.a = 0.0
	update_health()
	update_ship_progress()
	#var rand_enemy = randi_range(2,3)
	#spawn_enemies(rand_enemy)
	interaction_ui.hide()
	print(ship.position)
	
	

func fade_out():
	var tween := create_tween()
	tween.tween_property(fade_transition, "color:a", 1.0 , 0.3)
	await tween.finished

#This physic function was put in the level script just for active frame debuging. 
#However this could be a very cool "Cursor" or "Aim/Reticle" in a different game.
func _physics_process(_delta: float) -> void:
	placement_pos = player.position + player.last_direction * 8 #+ Vector2(0,1)
	var pos = placement_pos
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	$Layers/DebugLayer.clear()
	$Layers/DebugLayer.set_cell(grid_coord, 0, Vector2i(0,0))

func _process(delta: float) -> void:
	#Create a ratio of how much of the day has passed from 0 to 1.
	Scores.score_total_time += delta
	var daytime_point = 1 - ($Timers/DayTimer.time_left / $Timers/DayTimer.wait_time)
	var color = daytime_color.sample(daytime_point)
	var day_time = $Timers/DayTimer.time_left
	var night_time = $Timers/NightTimer.time_left
	main_ui.update_time(day_time, night_time, day_timer)
	#print(daytime_point)
	$Overlay/DayTimeColor.color = color
	update_health()
	update_ship_progress()
	check_ship()
	
	#"Tab" is input for day change by button press. Commenting out for now.
	#if Input.is_action_just_pressed("day_change"):
		#day_restart()
	
	#"pause_menu" opens up the InteractionUI but for a game pause
	if Input.is_action_just_pressed("pause_menu"):
		if game_paused == false:
			Engine.time_scale = 0.0
			pause_menu_ui.show()
			pause_menu_ui.grab_control_focus()
			game_paused = true
		else:
			Engine.time_scale = 1.0
			pause_menu_ui.hide()
			game_paused = false
		
		
	#Spawn extra waves of Enemies after Day 1. Adjust difficulty as necessary.
	if day == 1:
		extra_wave = true
	else:
		extra_wave = false
	#This additional enemy spawn can't be in the process function as written. Need to move or fix. Currently glitches and spawns infinite blobs.
	if int(night_time) == 40 and extra_wave == false:
		extra_wave = true
		$Timers/WaveTimer.start()

	
	if ship.ship_health >= ship.max_ship_health and interaction_ui.grab_focus_once == false and repair_ship_message == false:
		repair_ship_message = true
		var final_message:String = 'Enough Wood Has Been Collected!'
		print(final_message)
		main_ui.update_message(final_message)
	

	
	if Input.is_action_just_pressed("inventory"):
		$Overlay/CanvasLayer/InventoryContainer.visible = not $Overlay/CanvasLayer/InventoryContainer.visible
	
	if Input.is_action_just_pressed("build"):
		#Can use enums to select different builds, but for now build a box
		#if player.inventory.count(Enum.Item.WOOD) >= 1:
			#var craft = Enum.Craft.BOX
			#build(craft, placement_pos)
			#remove_inventory(Enum.Item.WOOD)
		if player.inventory.count(Enum.Item.STONE) >= 12:
			var craft = Enum.Craft.PYRE
			build(craft, placement_pos)
			for num in range(12):
				remove_inventory(Enum.Item.STONE)
				Scores.score_pyres_built += 1

	if player.health < player.max_health:
		main_ui.show_heal()
	else:
		main_ui.hide_heal()

	if Input.is_action_just_pressed("Heal"):
		if player.health < player.max_health:
			if player.inventory.count(Enum.Item.APPLE) > 0:
				remove_inventory(Enum.Item.APPLE)
				player.health += 1
				Scores.score_apples_eaten += 1
			else:
				var message:String = "Not enough food"
				print(message)
				main_ui.update_message(message)
			
	
	#Monitor the player for any items collected via "Body_entered" interactions with Area2D in other scenes.
	if player.new_item == true:
		var item_dropped = player.current_inventory
		add_inventory(item_dropped)
		player.new_item = false

	if player.death == true or ship.death == true:
		player_dead() 

func update_health():
	var health = player.health 
	var max_health = player.max_health
	main_ui.update_health(max_health, health)

func update_ship_progress():
	var health = ship.ship_health 
	var max_health = ship.max_ship_health
	main_ui.update_ship_progress(max_health, health)

#Populate trees in random position via markers on the map (called in ready function)
func spawn_trees(num: int):
	var tree_markers = $Objects/TreeSpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = tree_markers.pop_at(randi_range(0, tree_markers.size()-1))
		var new_tree = tree_scene.instantiate()
		new_tree.chop.connect(_on_tree_chop)
		$Objects.add_child(new_tree)
		new_tree.position = pos_marker.position

func spawn_rocks(num: int):
	var rock_markers = $Objects/RockSpawnPositions.get_children().duplicate(true)
	for i in num:
		var pos_marker = rock_markers.pop_at(randi_range(0, rock_markers.size()-1))
		var new_rock = rock_scene.instantiate()
		new_rock.smash.connect(_on_rock_smash)
		$Objects.add_child(new_rock)
		new_rock.position = pos_marker.position

func spawn_reward(reward_scene):
	var reward_markers = $Objects/RewardSpawnPositions.get_children().duplicate(true)
	var pos_marker = reward_markers.pop_at(randi_range(0,reward_markers.size()-1))
	var new_reward = reward_scene.instantiate()
	$Objects.add_child(new_reward)
	new_reward.position = pos_marker.position
	
	

func spawn_enemies(num: int):
	var enemy_markers = $Objects/EnemySpawnPositions.get_children().duplicate(true)
	print("spawned enemies: " + str(num))
	for i in num:
		var pos_marker = enemy_markers.pop_at(randi_range(0, enemy_markers.size()-1))
		var new_enemy = enemy_scene.instantiate()
		new_enemy.slice.connect(_on_blob_slice)
		new_enemy.ship_damaged.connect(_on_blob_ship_damaged)
		$Objects.add_child(new_enemy)
		new_enemy.position = pos_marker.position



#Build when 'B' Input map action is pressed (called in process function)
func build(craft: Enum.Craft, pos: Vector2):
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	if grid_coord not in used_cells:
		if craft == Enum.Craft.BOX:
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
		if craft == Enum.Craft.PYRE:
			#preload and Instantiate the Pyre Scene
			var pyre = pyre_scene.instantiate()
			#add_child(box)
			pyre.entered_pyre.connect(_on_pyre_entered_pyre)
			pyre.setup(grid_coord, $Objects)
			used_cells.append(grid_coord)
			#Test out removing the layer with navigation and placing a tile without navigation.
			$Layers/GrassLayer.erase_cell(grid_coord)
			$Layers/SoilLayer.set_cells_terrain_connect([grid_coord], 0, 0)

#This will toggle the plant info bar on/off by pressing the diagnose button "N"
#func _on_player_diagnose() -> void:
	#$Overlay/CanvasLayer/PlantInfoContainer.visible = not $Overlay/CanvasLayer/PlantInfoContainer.visible

func _on_chop():
	player.current_tool = Enum.Tool.AXE

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
				if object.position.distance_to(pos)< 20 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.stone:
						if player.inventory.count(Enum.Item.STONE) == 0:
							var stone_message = "Yes stones.\nI can build something strong with these."
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(stone_message, Enum.Item.STONE)
							main_ui.update_message(stone_message)
						var item_drop = Enum.Item.STONE
						var stone_dropped = randi_range(6,10)
						for num in stone_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_stone_collected += 1
			#For now group for GiantPyre has been changed to new group 'GreatPyre'.
			for object in get_tree().get_nodes_in_group('GreatPyre'):
				if object.position.distance_to(pos)< 50 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.stone:
						if player.inventory.count(Enum.Item.STONE) == 0:
							var stone_message = "Yes stones.\nI can build something strong with these."
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(stone_message, Enum.Item.STONE)
							main_ui.update_message(stone_message)
						var item_drop = Enum.Item.STONE
						var stone_dropped = 1
						for num in stone_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_stone_collected += 1
			for object in get_tree().get_nodes_in_group('Pyres'):
				if object.position.distance_to(pos)< 20 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.stone:
						if player.inventory.count(Enum.Item.STONE) == 0:
							var stone_message = "Yes stones.\nI can build something strong with these."
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(stone_message, Enum.Item.STONE)
							main_ui.update_message(stone_message)
						var item_drop = Enum.Item.STONE
						var stone_dropped = 6
						for num in stone_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_stone_collected += 1
			#Currently all stumps are still managed by the "Tree" sceene in group 'Objects'.
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos)< 20 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.stump_wood:
						var item_drop = Enum.Item.WOOD
						var wood_dropped = 2
						for num in wood_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_wood_collected += 1
		Enum.Tool.SWORD:
			#For now group for blob has been changed from 'Objects' to new group 'Enemy'.
			for object in get_tree().get_nodes_in_group('Enemy'):
				if object.position.distance_to(pos) < 20 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.gold:
						if player.inventory.count(Enum.Item.GOLD) == 0:
							var gold_message = "I found some grains of gold in this slime.\nBut what use is gold on this forsaken island?"
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(gold_message, Enum.Item.GOLD)
							main_ui.update_message(gold_message)
						var item_drop = Enum.Item.GOLD
						var gold_dropped = randi_range(3,3+day*2)
						for num in gold_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_gold_collected += 1
		Enum.Tool.AXE:
			#For now group for blob has been changed from 'Objects' to new group 'Enemy'.
			for object in get_tree().get_nodes_in_group('Enemy'):
				if object.position.distance_to(pos)< 13 and (object.position.direction_to(player.position).round() == -player.last_direction):
					print(object.position.distance_to(pos))
					object.hit(tool)
					if object.gold:
						if player.inventory.count(Enum.Item.GOLD) == 0:
							var gold_message = "I found some grains of gold in this slime.\nBut what use is gold on this forsaken island?"
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(gold_message, Enum.Item.GOLD)
							main_ui.update_message(gold_message)
						var item_drop = Enum.Item.GOLD
						var gold_dropped = randi_range(3,3+day*2)
						for num in gold_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_gold_collected += 1
			#Currently all trees are in group 'Objects'.
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos) < 13 and (object.position.direction_to(player.position).round() == -player.last_direction):
					#print(player.last_direction)
					print(object.position.distance_to(pos))
					#print(object.position.direction_to(player.position).round())
					object.hit(tool)
					if object.apples:
						if player.inventory.count(Enum.Item.APPLE) == 0:
							var apple_message = "An Apple!\nThank Odinson, I am starving.\nI need to find more of these to take with me."
							await get_tree().create_timer(0.05).timeout
							#interaction_tool(apple_message, Enum.Item.APPLE)
							main_ui.update_message(apple_message)
						var item_drop = Enum.Item.APPLE
						player.inventory.append(item_drop)
						add_inventory(item_drop)
						Scores.score_apples_collected += 1
					if object.wood:
						var item_drop = Enum.Item.WOOD
						var wood_dropped = randi_range(4,8)
						for num in wood_dropped:
							player.inventory.append(item_drop)
							add_inventory(item_drop)
							Scores.score_wood_collected += 1
						

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
	update_inventory(item_added)

#Update inventory function take the Enum.Item being added or removed and updates it
func update_inventory(item_updated : Enum.Item):
	#create new var count for the number of that item found in the player.inventory array, and pass that information into the "update_all" function
	var count = player.inventory.count(item_updated)
	$Overlay/CanvasLayer/InventoryContainer.update_all(count, item_updated)

func remove_all(item_enum: Enum.Item):
	while player.inventory.count(item_enum) > 0:
		remove_inventory(item_enum)

func remove_inventory(item_removed: Enum.Item):
	#Remove one matching item from the inventory using "erase"
	player.inventory.erase(item_removed)
	#print(player.inventory)
	update_inventory(item_removed)
#endregion

#Create the transition to the gameover screen
func player_dead():
	Scores.score_dead = true
	fade_out_audio($Music/DayMusic)
	fade_out_audio($Music/NightMusic)
	Engine.time_scale = 0.1
	fade_out()
	await get_tree().create_timer(0.3).timeout
	death_screen()

func fade_out_audio(audio_player: AudioStreamPlayer2D):
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", -80.0, 1.0)

func death_screen():
	get_tree().change_scene_to_file("res://scenes/ui/death_screen.tscn")

#region Day Restart and Level Reset
#"Day_restart" function calls the "Level_reset" via callback in the middle of the circle transistion/animation for the day change
func day_restart():
	#Survival Mode will require food to be consumed each day. Subtract 1 apple each day:
	#need to remove ten apples from the player.inventory array
	for number in range(1):
		#May need to improve this to take damage if not enough apples
		if player.inventory.count(Enum.Item.APPLE) > 0:
			remove_inventory(Enum.Item.APPLE)
			Scores.score_apples_eaten += 1 
		else:
			player.health -= 1
			if player.health <= 0:
				Scores.starved_dead = true
	
	#adjust the shader parameter that creates the circle transistion
	var tween = create_tween()
	tween.tween_property($Overlay/CanvasLayer/DayTransitionLayer.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property($Overlay/CanvasLayer/DayTransitionLayer.material, "shader_parameter/progress", 0.0, 1.0)


func level_reset():
	for plant in get_tree().get_nodes_in_group('Plants'):
		#If there is water on the tile, then plant function grow can be completed
		plant.grow(plant.coord in $Layers/SoilWaterLayer.get_used_cells())
	for enemy in get_tree().get_nodes_in_group('Enemy'):
		if enemy.health > 0 and enemy.is_dead == false:
			enemy.death()
			Scores.score_enemies_killed_by_daylight += 1
	$Overlay/CanvasLayer/PlantInfoContainer.update_all()
	$Layers/SoilWaterLayer.clear()
	$Music/NightMusic.stop()
	$Timers/DayTimer.start()
	$Music/DayMusic.play()
	day_timer = true
	day += 1
	Scores.score_days_survived += 1
	main_ui.update_day(day)
	#This code will search for all object (Trees or other) that have a reset function and will execute the reset.
	for object in get_tree().get_nodes_in_group('Objects'):
		if 'reset' in object:
			object.reset()
	#New item arrivals:
	if day == 2:
		spawn_reward(seed_scene)
		await get_tree().create_timer(0.05).timeout
		var reward_seed = $Objects/ToolSeed
		reward_seed.seed_found.connect(_on_tool_seed_seed_found)
		spawn_reward(water_scene)
		await get_tree().create_timer(0.05).timeout
		var reward_water = $Objects/ToolWater
		reward_water.water_found.connect(_on_tool_water_water_found)
	#if day == 4:
		#spawn_reward(hoe_scene)
	if day == 8:
		spawn_reward(toy_scene)
		await get_tree().create_timer(0.05).timeout
		var reward_toy = $Objects/RewardToy
		reward_toy.toy_found.connect(_on_reward_toy_toy_found)
#endregion

#After a plany dies, delete cells used by that plant from the used_cells array
func plant_death(coord: Vector2i):
	used_cells.erase(coord)

func spawn_rand_enemies():
	#Spawn increasing amounts of enemies every day
	var min_blobs = 3
	if day > 3:
		min_blobs = day
	var rand_enemy = randi_range(min_blobs, day + 3)
	spawn_enemies(rand_enemy)

func _on_day_timer_timeout() -> void:
	day_timer = false
	var message : String 
	if day == 1:
		message = "There is something eerie about this darkness."
	else:
		message = "Defend against the darkness!"
	main_ui.update_message(message)
	spawn_rand_enemies()
	$Music/DayMusic.stop()
	$Timers/NightTimer.start()
	$Music/NightMusic.play()

func _on_night_timer_timeout() -> void:
	day_restart()


func _on_tree_chop():
	player.current_tool = Enum.Tool.AXE
	print(player.current_tool)

func _on_rock_smash():
	player.current_tool = Enum.Tool.PICKAXE
	print(player.current_tool)
	
func _on_blob_slice():
	player.current_tool = Enum.Tool.SWORD
	print(player.current_tool)


func _on_main_ui_heal() -> void:
	player.heal_click =  true
	$Timers/HealTimer.start()
	if player.health < player.max_health:
		if player.inventory.count(Enum.Item.APPLE) > 0:
			remove_inventory(Enum.Item.APPLE)
			player.health += 1
		else:
			var message:String = "Not enough food"
			print(message)
			main_ui.update_message(message)



func _on_heal_timer_timeout() -> void:
	player.heal_click =  false


func _on_pyre_entered_pyre(body) -> void:
	if body.is_in_group('Enemy'):
		if body.health > 0 and body.is_dead == false:
			print('Enemy')
			body.death()
			Scores.score_enemies_killed_by_pyre += 1
	else:
		print('Friend')


func _on_giant_pyre_entered_giant_pyre() -> void:
	var message:String = "So many stones"
	print(message)
	main_ui.update_message(message)
	if giant_pyre_visited == false:
		await get_tree().create_timer(0.05).timeout
		#var interaction_message : String = 'Someone built this a long time ago.\nIt looks like a great fire used to burn on top.\n\nCould I build something like this?'
		#var interaction_message : String = 'Whoa! How is this great stone pyre here?'
		#interaction_visit(interaction_message, Enum.Visit.PYRE)

func freeze_level():
	for enemy in get_tree().get_nodes_in_group('Enemy'):
		enemy.normal_speed = 0
		enemy.leap_force = 0
	if $Timers/DayTimer.is_stopped():
		$Timers/NightTimer.paused = true
	else:
		$Timers/DayTimer.paused = true

func unfreeze_level():
	for enemy in get_tree().get_nodes_in_group('Enemy'):
		if enemy.color_selected == Enum.Blob.RED:
			enemy.normal_speed = 70
		else:
			enemy.normal_speed = 30
			enemy.leap_force = 55
	if $Timers/DayTimer.paused == true:
		$Timers/DayTimer.paused = false
	else:
		$Timers/NightTimer.paused = false
	$Dungeon.show()

func _on_giant_pyre_entered_dungeon() -> void:
	print("Entered Dungeon!")
	$Dungeon.enable_layers()
	for object in get_tree().get_nodes_in_group('GreatPyre'):
		object.call_deferred("disable_collision_polygon")
	freeze_level()
	giant_pyre_doorway = true
	$Layers.hide()
	$Layers/GrassLayer.enabled = false
	$Objects.hide()
	$Dungeon.show()
	

func _on_dungeon_exit_dungeon() -> void:
	$Dungeon.disable_layers()
	unfreeze_level()
	for object in get_tree().get_nodes_in_group('GreatPyre'):
		object.call_deferred("enable_collision_polygon")
	$Objects/GiantPyre.show_exit_area()
	$Dungeon.inside_dungeon = false
	$Layers.show()
	$Layers/GrassLayer.enabled = true
	$Objects.show()


func _on_giant_pyre_exited_pyre_doorway() -> void:
	$Objects/GiantPyre.hide_exit_area()

func interaction_visit(message : String, visit : Enum.Visit):
	interaction_ui.update_message(message)
	interaction_ui.select()
	interaction_ui.add_ok_button(visit)
	interaction_ui.show()
	Engine.time_scale = 0

func interaction_tool(message : String, interaction):
	print("interact")
	interaction_ui.update_message(message)
	interaction_ui.select()
	interaction_ui.add_take_button(interaction)
	interaction_ui.show()
	Engine.time_scale = 0


func _on_ship_enter_ship(body) -> void:
	var message:String 
	if body.is_in_group('Enemy'):
		print('Enemy')
		body.tracking = true
		message = 'My SHIP! They are attacking my ship!'
	else:
		at_ship = true
		repair_ship_message = false
		if ship.ship_health < ship.max_ship_health and player.inventory.count(Enum.Item.WOOD) >= 1:
			var wood_total = player.inventory.count(Enum.Item.WOOD)
			print(wood_total)
			ship.ship_health += wood_total
			remove_all(Enum.Item.WOOD)
			print('Ship Health: ' + str(ship.ship_health))
		if ship_visited == false:
			await get_tree().create_timer(0.05).timeout
			var interaction_message : String = 'My ship is damaged.\nI will need to collect wood to repair it.'
			#interaction_visit(interaction_message, Enum.Visit.SHIP)
			main_ui.update_message(interaction_message)
		print('Friend')
		message = 'Collect more wood!'
	main_ui.update_message(message)


func check_ship():
	if at_ship == true and ship.ship_health < ship.max_ship_health:
		var message = 'Collect more wood!'
		main_ui.update_message(message)
	if at_ship == true and ship.ship_health >= ship.max_ship_health and interaction_ui.grab_focus_once == false and no_repair == false:
		interaction_ui.select()
		#await get_tree().create_timer(0.05).timeout
		var interaction_message : String = 'Repair Ship and Set Sail Now?'
		interaction_ui.update_message(interaction_message)
		interaction_ui.show()
		Engine.time_scale = 0


func _on_ship_exit_ship(body) -> void:
	at_ship = false
	if body.is_in_group('Enemy'):
		print('Enemy')
		body.tracking = false
	await get_tree().create_timer(1.0).timeout
	interaction_ui.grab_focus_once = false
	


func _on_interaction_ui_no() -> void:
	interaction_ui.grab_focus_once = true
	print("More Work To Do!")
	$Timers/NoRepairTimer.start()
	no_repair = true
	interaction_ui.hide()
	Engine.time_scale = 1


func _on_interaction_ui_yes() -> void:
	interaction_ui.grab_focus_once = true
	interaction_ui.hide()
	Engine.time_scale = 1
	await get_tree().create_timer(1.0).timeout
	print("You Survived The Island!")
	get_tree().change_scene_to_file("res://scenes/Cutscenes/cutscene.tscn")

func update_visit(visit):
	if visit == Enum.Visit.SHIP:
		ship_visited = true
	if visit == Enum.Visit.PYRE:
		giant_pyre_visited = true


func _on_interaction_ui_ok(visit: Enum.Visit) -> void:
	update_visit(visit)
	interaction_ui.hide()
	Engine.time_scale = 1

func _on_interaction_ui_take(_interaction: Enum.Tool) -> void:
	interaction_ui.hide()
	Engine.time_scale = 1

func _on_tool_axe_axe_found() -> void:
	await get_tree().create_timer(0.05).timeout
	var interaction_message : Array[String] = ['Who needs a sword or a bow, when you can have an AXE!','My AXE!\nI wonder what else has washed ashore?']
	#interaction_tool(interaction_message, Enum.Tool.AXE)
	main_ui.update_message(interaction_message.pick_random())

func _on_tool_hoe_hoe_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'Who needs a sword or a bow, when you can have an AXE!'
	var interaction_message : String = 'Look a Hoe!\nI better not yell that too much.'
	#interaction_tool(interaction_message, Enum.Tool.HOE)
	main_ui.update_message(interaction_message)

func _on_tool_water_water_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'Who needs a sword or a bow, when you can have an AXE!'
	var interaction_message : String = 'A watering can!\nIf I plant seeds, I can water them to grow'
	#interaction_tool(interaction_message, Enum.Tool.WATER)
	main_ui.update_message(interaction_message)

func _on_tool_seed_seed_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'Who needs a sword or a bow, when you can have an AXE!'
	var interaction_message : String = 'Seeds!\nIf I plant seeds, I can water them to grow'
	#interaction_tool(interaction_message, Enum.Tool.WATER)
	main_ui.update_message(interaction_message)

func _on_reward_toy_toy_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'Who needs a sword or a bow, when you can have an AXE!'
	var interaction_message : String = 'I know this Toy.\nI need to make it home.'
	#need to update interation, to include new enum of rewards
	#interaction_tool(interaction_message, Enum.Tool.WATER)
	main_ui.update_message(interaction_message)

func _on_tool_sword_sword_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'You have my Sword!'
	var interaction_message : String = 'Whoa a Sword!\nThe pointy end goes in the enemy!'
	#interaction_tool(interaction_message, Enum.Tool.SWORD)
	main_ui.update_message(interaction_message)


func _on_tool_pickaxe_pickaxe_found() -> void:
	await get_tree().create_timer(0.05).timeout
	#var interaction_message : String = 'You have my Sword!'
	var interaction_message : String = 'This looks useful.\nMaybe for smashing?'
	#interaction_tool(interaction_message, Enum.Tool.PICKAXE)
	main_ui.update_message(interaction_message)

#Need to Connect in the enemy_spawn function
func _on_blob_ship_damaged() -> void:
	Scores.score_ship_damage_taken += 1
	ship.ship_health -= 1

func _on_wave_timer_timeout() -> void:
	spawn_rand_enemies()
	extra_wave = false

func _on_no_repair_timer_timeout() -> void:
	no_repair = false

func _on_dungeon_approach_statue() -> void:
	var message = "WHO ENTERS MY LAIR?"
	main_ui.update_message(message)
	print(message)
