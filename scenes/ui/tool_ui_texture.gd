extends Control

var tool_enum: Enum.Tool
var seed_enum: Enum.Seed

func setup_tool(new_tool_enum: Enum.Tool, main_texture: Texture2D):
	tool_enum = new_tool_enum
	$TextureRect.texture = main_texture

func setup_seed(new_seed_enum: Enum.Seed, main_texture: Texture2D):
	seed_enum = new_seed_enum
	$TextureRect.texture = main_texture

func highlight(selected: bool):
	var tween = create_tween()
	var target_size = Vector2(20,20) if selected else Vector2(16,16)
	#Set the property "custom_minimum_size" of the "TextureRect" here in this "Tool_UI_texture" scene, to the "target_size" of 20x20 or 16x16, with a duration for the change of 0.1 seconds.
	tween.tween_property($TextureRect, "custom_minimum_size", target_size, 0.1)
