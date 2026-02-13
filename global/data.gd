extends Node

const PLAYER_SKINS = {
	Enum.Style.BASIC: {'texture' : preload("res://graphics/characters/main/main_basic.png")},
	Enum.Style.WESLEY:{'texture' : preload("res://graphics/characters/main/main_welsey.png")},
	Enum.Style.VIKING:{'texture' : preload("res://graphics/characters/main/main_viking.png")},
	Enum.Style.BASEBALL: preload("res://graphics/characters/main/main_blue.png"),
	Enum.Style.COWBOY: preload("res://graphics/characters/main/main_cowboy.png"),
	Enum.Style.ENGLISH: preload("res://graphics/characters/main/main_grey.png"),
	Enum.Style.STRAW: preload("res://graphics/characters/main/main_straw.png"),
	Enum.Style.BEANIE: preload("res://graphics/characters/main/main_red.png")}
const TILE_SIZE = 16
const PLANT_DATA = {
	Enum.Seed.TOMATO: {
		'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/tomato.png",
		'name':'Tomato',
		'h_frames': 3,
		'grow_speed': 1.5,
		'death_max': 2,
		'reward': Enum.Item.TOMATO},
	Enum.Seed.CORN: {
		'texture': "res://graphics/plants/corn.png",
		'icon_texture': "res://graphics/icons/corn.png",
		'name':'Corn',
		'h_frames': 3,
		'grow_speed': 1,
		'death_max': 3,
		'reward': Enum.Item.CORN},
	Enum.Seed.PUMPKIN: {
		'texture': "res://graphics/plants/pumpkin.png",
		'icon_texture': "res://graphics/icons/pumpkin.png",
		'name':'Pumpkin',
		'h_frames': 3,
		'grow_speed': 0.5,
		'death_max': 3,
		'reward': Enum.Item.PUMPKIN},
	Enum.Seed.WHEAT: {
		'texture': "res://graphics/plants/wheat.png",
		'icon_texture': "res://graphics/icons/wheat.png",
		'name':'Wheat',
		'h_frames': 3,
		'grow_speed': 0.75,
		'death_max': 3,
		'reward': Enum.Item.WHEAT}}
const INVENTORY_DATA = {
	Enum.Item.WOOD: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/wood.png",
		'name':'Wood',
		'cost': 2},
	Enum.Item.STONE: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture':"res://graphics/icons/stone.png",
		'name':'Stone',
		'cost': 2},
	Enum.Item.GOLD: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture':"res://graphics/icons/gold.png",
		'name':'Gold'},
	Enum.Item.APPLE: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/apple.png",
		'name':'Apple',
		'details':'10 apples a day keep\nthe witchdoctor away',
		'cost': 2},
	Enum.Item.TOMATO: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/tomato.png",
		'name':'Tomato'},
	Enum.Item.CORN: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/corn.png",
		'name':'Corn'},
	Enum.Item.PUMPKIN: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/pumpkin.png",
		'name':'Pumpkin'},
	Enum.Item.WHEAT: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/wheat.png",
		'name':'Wheat'},
	Enum.Item.TOMATO_SEED: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/tomato_seed.png",
		'name':'Tomato Seed',
		'details':'Plant in soil, water for 2 days\nYields Tomato that adds 0.5 day of food ration.',
		'cost': 4},
	Enum.Item.CORN_SEED: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/corn_seed.png",
		'name':'Corn_Seed',
		'details':'Plant in soil, water for 3 days\nYields Corn that adds 1 day of food ration.',
		'cost': 6},
	Enum.Item.PUMPKIN_SEED: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/pumpkin_seed.png",
		'name':'Pumpkin_Seed',
		'details':'Plant in soil, water for 6 days\nYields Pumpkin that adds 3 days of food ration.',
		'cost': 10},
	Enum.Item.WHEAT_SEED: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/wheat_seed.png",
		'name':'Wheat_Seed',
		'details':'Plant in soil, water for 4 days\nYields Wheat that adds 1.5 day of food ration.',
		'cost': 8},
	Enum.Item.ARMOR: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/armor.png",
		'name':'Armor',
		'cost': 2},
	Enum.Item.HEART: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/Heart.png",
		'name':'Blessing of Health',
		'details':'Increase maximum health by 15',
		'cost': 50},
	Enum.Item.STRENGTH: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/strength.png",
		'name':'Blessing of Strength',
		'details':'Increase you strength to slay\nBlobs with a single strike',
		'cost': 50},
	Enum.Item.SPEED: {
		#'texture': "res://graphics/plants/tomato.png",
		'icon_texture': "res://graphics/icons/speed.png",
		'name':'Blessing of Speed',
		'details':'Increase walking and dashing speed by 50%',
		'cost': 50},
		}
const MACHINE_UPGRADE_COST = {
	Enum.Machine.SPRINKLER: {
		'name': 'Sprinkler',
		'cost' :{Enum.Item.TOMATO: 30, Enum.Item.WHEAT: 20},
		'icon': preload("res://graphics/icons/sprinkler.png")},
	Enum.Machine.FISHER: {
		'name': 'Sprinkler',
		'cost' :{Enum.Item.WOOD: 25, Enum.Item.FISH: 15},
		'icon': preload("res://graphics/icons/fisher.png")},
	Enum.Machine.SCARECROW: {
		'name': 'Sprinkler',
		'cost' : {Enum.Item.PUMPKIN: 15, Enum.Item.CORN: 15},
		'icon': preload("res://graphics/icons/scarecrow.png")}}
const HOUSE_COST = {
	1: {Enum.Item.WOOD: 30, Enum.Item.APPLE: 20},
	2: {Enum.Item.WOOD: 40, Enum.Item.APPLE: 30}}
const STYLE_UPGRADES = {
	Enum.Style.COWBOY: {
		'name': 'Cowboy',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/cowboy.png")},
	Enum.Style.ENGLISH: {
		'name': 'Oldie',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/english.png")},
	Enum.Style.BASEBALL: {
		'name': 'Baseball',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/blue.png")},
	Enum.Style.BEANIE: {
		'name': 'Beanie',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/beanie.png")},
	Enum.Style.STRAW: {
		'name': 'Straw',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/straw.png")}}
const TOOL_STATE_ANIMATIONS = {
	Enum.Tool.HOE: 'Hoe',
	Enum.Tool.AXE: 'Axe',
	Enum.Tool.WATER: 'Water',
	Enum.Tool.SWORD: 'Sword',
	Enum.Tool.FISH: 'Fish',
	Enum.Tool.SEED: 'Seed',
	Enum.Tool.PICKAXE: 'Pickaxe'
	}
const CRAFT_DATA = {
	Enum.Craft.BOX: {
		'texture': "res://graphics/objects/table.png",
		#'icon_texture': "res://graphics/icons/wood.png",
		'name':'Box'},
	Enum.Craft.WALL: {
		'texture': "res://graphics/objects/table.png",
		#'icon_texture':"res://graphics/icons/blue.png",
		'name':'Wall'},
	Enum.Craft.PYRE: {
		'texture': "res://graphics/objects/Pyre1.png",
		#'icon_texture': "res://graphics/objects/Pyre1.png",
		'name':'Pyre'}
}
const VISIT_DATA = {
	Enum.Visit.SHIP: {
		'message' : 'My ship is damaged.\nI will need to collect wood to repair it.'},
	Enum.Visit.PYRE: {
		'message' : 'Someone built this a long time ago.\nIt looks like a great fire used to burn on top.'
	}
}
