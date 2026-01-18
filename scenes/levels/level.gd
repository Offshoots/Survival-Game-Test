extends Node2D

var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/ui/plant_info.tscn")
var used_cells: Array[Vector2i]
@onready var player = $Objects/Player
@onready var tree = $Objects/Tree
@export var daytime_color: Gradient

#This physic function was put in the level script just for active frame debuging. 
#However this could be a very cool "Cursor" or "Aim/Reticle" in a different game.
func _physics_process(_delta: float) -> void:
	var pos = player.position + player.last_direction * 16 + Vector2(0,4)
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE) , int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	$Layers/DebugLayer.clear()
	$Layers/DebugLayer.set_cell(grid_coord, 0, Vector2i(0,0))

func _process(_delta: float) -> void:
	#Create a ratio of how much of the day has passed from 0 to 1.
	var daytime_point = 1 - ($Timers/DayTimer.time_left / $Timers/DayTimer.wait_time)
	var color = daytime_color.sample(daytime_point)
	#print(daytime_point)
	$Overlay/DayTimeColor.color = color
	if Input.is_action_just_pressed("day_change"):
		day_restart()

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
				
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos)< 20:
					object.hit(tool)

#This will toggle the plant info bar on/off by pressing the diagnose button "N"
func _on_player_diagnose() -> void:
	$Overlay/CanvasLayer/PlantInfoContainer.visible = not $Overlay/CanvasLayer/PlantInfoContainer.visible

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
	
	#My attempt work but did not queue free individual apples during reset
	#var apples = tree.get_node('Apples').get_children().size()
	#print(apples)
	##still a little buggy, goes to >4 apples sometimes
	#if apples < 3:
		#tree.create_apples(apples + 1)


func plant_death(coord: Vector2i):
	used_cells.erase(coord)
	#print(used_cells)
