class_name PlantResource extends Resource

@export var texture: Texture2D
@export var icon_texture: Texture2D
@export var name: String
@export var grow_speed : float = 1.0
@export var h_frames: int = 3
@export var death_max: int = 3
@export var reward: Enum.Item
var dead_plant = preload("res://graphics/plants/stump.png")

var coord: Vector2i
var age: float
var death_count: int
var dead: bool:
	set(value):
		dead = value
		#Use the "emit_changed" function so that you can detect changes in the game to be used elsewhere in the code.
		#Emit_changed on the death of a plant when the Bool is true from Harvesting "On_body_entered" function the plant in "Plant" scene.
		emit_changed()

#create death signal and connect it when the plant is placed via the death_coord
signal death(coord: Vector2i)

func setup(seed_enum: Enum.Seed):
	texture = load(Data.PLANT_DATA[seed_enum]['texture'])
	icon_texture = load(Data.PLANT_DATA[seed_enum]['icon_texture'])
	name = Data.PLANT_DATA[seed_enum]['name']
	grow_speed = Data.PLANT_DATA[seed_enum]['grow_speed']
	h_frames = Data.PLANT_DATA[seed_enum]['h_frames']
	death_max = Data.PLANT_DATA[seed_enum]['death_max']
	#reward = Data.PLANT_DATA[seed_enum]['reward']

#passing the sprite in from the plant scene allows us to update the frame to a new "Growth" stage.
func grow(sprite: Sprite2D):
	#Cap the age at the last hframe
	age = min(grow_speed + age, h_frames)
	sprite.frame = int(age)
	death_count = 0

#Die func not Used for anything now
func die(sprite: Sprite2D):
	#currently a stump png
	#The new texture can be adjusted to the correct frame. Some x/y positions may 
	sprite.texture = dead_plant
	sprite.hframes = 1
	sprite.vframes = 1
	sprite.frame = 0

func death_coord(grid_coord: Vector2i, plant_death_func):
	coord = grid_coord
	death.connect(plant_death_func)

func decay(plant: StaticBody2D, dry_days: int):
	death_count = dry_days
	if death_count >= death_max:
		emit_changed()
		#emit the death signal and pass the coordinate "coord" from the death_coordintate function.
		death.emit(coord)
		plant.queue_free()

func get_complete():
	return age >= h_frames
	
