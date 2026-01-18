#@tool #this allows code to run inside the editor. Our example bush will rotate now in the editor.
extends StaticBody2D

@export_range(0,3,1) var size: int
@export_enum('Bush', 'Rock') var style: int
@export var random: bool
#@export_tool_button('Randomize Button', "Callable") var randomizer = randomize

func _ready() -> void:
	if random:
		size = randi_range(0, $Sprite2D.hframes - 1)
		style = randi_range(0,1)
	$Sprite2D.frame_coords = Vector2i(size, style)
	$CollisionShape2D.disabled = size < 2
	#Change the Z index so small rocks are always in the backround (we pas over them) and they do not get Y sorted to be in front.
	z_index = -1 if size < 2 else 0

#func randomize():
	#size = randi_range(0, $Sprite2D.hframes - 1)
	#style = randi_range(0,1)
	#$Sprite2D.frame_coords = Vector2i(size, style)
