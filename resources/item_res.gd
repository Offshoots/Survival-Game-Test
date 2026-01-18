class_name MapResource extends Resource
#Manages resoure data for trees and boulders for lumber and stone (or other mineral) rewards to player

@export var texture: Texture2D
@export var icon_texture: Texture2D
@export var name: String

func setup(item_enum: Enum.Item):
	#texture = load(Data.INVENTORY_DATA[item_enum]['texture'])
	icon_texture = load(Data.INVENTORY_DATA[item_enum]['icon_texture'])
	name = Data.INVENTORY_DATA[item_enum]['name']
