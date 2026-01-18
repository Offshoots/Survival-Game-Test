extends StaticBody2D

var coord: Vector2i
@export var res: PlantResource
var dry_days: int = 0

signal death(coord: Vector2i)

func setup(grid_coord: Vector2i, parent: Node2D, new_res: PlantResource, plant_death_func):
	position = grid_coord * Data.TILE_SIZE + Vector2i(8 , 5)
	parent.add_child(self)
	coord = grid_coord
	res = new_res
	$FlashSprite2D.texture = res.texture
	death.connect(plant_death_func)

func grow(watered: bool):
	#If the bool passed into this grow function from the Level script is true then this script is run.
	#As a reminder we passed a function that would check to see if a tile watered would resolve as true
	if watered:
		#called the grow function in the resource script, where the calculation for age takes place.
		#Pass the current sprite into the grow function
		res.grow($FlashSprite2D)
		dry_days = 0
	else:
		#Added dry days for decay function
		dry_days += 1
		res.decay(self, dry_days)
		
		
		#My code for "die" function for plants.
		#dry_days += 1
		#if dry_days == 3:
			#res.die($Sprite2D)
		


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if res.get_complete():
		$FlashSprite2D.flash(0.2, 0.4, queue_free)
		death.emit(coord)
		res.dead = true
