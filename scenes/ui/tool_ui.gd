extends Control

const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png")}
const SEED_TEXTURES = {
	Enum.Seed.CORN: preload("res://graphics/icons/corn.png"),
	Enum.Seed.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Enum.Seed.TOMATO: preload("res://graphics/icons/tomato.png"),
	Enum.Seed.WHEAT: preload("res://graphics/icons/wheat.png")}

#By preloading the Tool Texture UI scene, we will have access to the new script and functions in that scene (such as "setup" func used inside of "texture_setup" below)
var tool_texture_scene = preload("res://scenes/ui/tool_ui_texture.tscn")
var seed_texture_scene = preload("res://scenes/ui/tool_ui_texture.tscn")

func _ready() -> void:
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES, $ToolContainer)
	$ToolContainer.hide()
	texture_setup(Enum.Seed.values(), SEED_TEXTURES, $SeedContainer)
	$SeedContainer.hide()
	
func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	if textures == TOOL_TEXTURES:
		for enum_id in enum_list:
			var tool_texture = tool_texture_scene.instantiate()
			#preloaded the Texture UI scene and now using the setup func, passing in each tool via enum_id in this for loop, and textures dictionary indexed for that enum_id
			tool_texture.setup_tool(enum_id, textures[enum_id])
			container.add_child(tool_texture)
	elif textures == SEED_TEXTURES:
		for enum_id in enum_list:
			var seed_texture = seed_texture_scene.instantiate()
			#preloaded the Texture UI scene and now using the setup func, passing in each tool via enum_id in this for loop, and textures dictionary indexed for that enum_id
			seed_texture.setup_seed(enum_id, textures[enum_id])
			container.add_child(seed_texture)

#Reveal and Hide Timer are both improvements to the visual queue of the tool GUI. 
#ToolGUI opens on button to cycle then closes 1 second later.
func reveal_tool():
	$HideTimer.start()
	$SeedContainer.hide()
	$ToolContainer.show()
	#In this case "Tool UI" scene is a child of the "Player" Scene so we can use "get_parent" to access the Player code which includes "current_tool"
	var target = get_parent().current_tool
	#Now we want to check for the texture of the current_tool and enlarge it when it is selected for a visual queue in the GUI.
	#We use a for loop and check each texture in the ToolConainer (via get_children) and look for the current_tool
	for texture in $ToolContainer.get_children():
		#highlight is a func we have created in the "Tool_ui_texture" script
		texture.highlight(target == texture.tool_enum)

func reveal_seed():
	$HideTimer.start()
	$ToolContainer.hide()
	$SeedContainer.show()
	#In this case "Tool UI" scene is a child of the "Player" Scene so we can use "get_parent" to access the Player code which includes "current_tool"
	var target = get_parent().current_seed
	#Now we want to check for the texture of the current_tool and enlarge it when it is selected for a visual queue in the GUI.
	#We use a for loop and check each texture in the ToolConainer (via get_children) and look for the current_tool
	for texture in $SeedContainer.get_children():
		#highlight is a func we have created in the "Tool_ui_texture" script
		texture.highlight(target == texture.seed_enum)

func _on_hide_timer_timeout() -> void:
	$ToolContainer.hide()
	$SeedContainer.hide()
