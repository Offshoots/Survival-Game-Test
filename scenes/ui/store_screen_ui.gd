extends Control

signal buy_item_1
signal buy_item_2
signal buy_item_3
signal nevermind

@onready var texture_rect_1: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect1
@onready var label_1: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label1
@onready var button_1: Button = $MarginContainer/HBoxContainer/VBoxContainer/Button1
@onready var texture_rect_2: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer2/TextureRect2
@onready var label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Label2
@onready var button_2: Button = $MarginContainer/HBoxContainer/VBoxContainer2/Button2
@onready var texture_rect_3: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer3/TextureRect3
@onready var label_3: Label = $MarginContainer/HBoxContainer/VBoxContainer3/Label3
@onready var button_3: Button = $MarginContainer/HBoxContainer/VBoxContainer3/Button3
@onready var return_button: Button = $MarginContainer/HBoxContainer/VBoxContainer4/ReturnButton

@onready var qty_label_1: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/QTYLabel1
@onready var more_button_1: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/MoreButton1
@onready var less_button_1: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/LessButton1
@onready var qty_label_2: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/QTYLabel2
@onready var qty_label_3: Label = $MarginContainer/HBoxContainer/VBoxContainer3/HBoxContainer/QTYLabel3




#Set up functions to set prices and exchange gold for items in inventory back on the level scence
var store_item_1 
var store_item_2 
var store_item_3
var cost_1
var cost_2
var cost_3
var quantity_item_1 = 0
var quantity_item_2 = 0
var quantity_item_3 = 0

func grab_focus_item_1():
	button_1.grab_focus()

func _on_button_1_pressed() -> void:
	buy_item_1.emit(store_item_1, cost_1, quantity_item_1)

func _on_button_2_pressed() -> void:
	buy_item_2.emit(store_item_2, cost_2, quantity_item_2)

func _on_button_3_pressed() -> void:
	buy_item_3.emit(store_item_3, cost_3, quantity_item_3)


func update_items(item_1 : Enum.Item, item_2 : Enum.Item, item_3 : Enum.Item):
	#Item 1
	store_item_1 = item_1
	cost_1 = Data.INVENTORY_DATA[item_1]['cost']
	texture_rect_1.texture = load(Data.INVENTORY_DATA[item_1]['icon_texture'])
	label_1.text = Data.INVENTORY_DATA[item_1]['name'] + "
	Cost: " + str(Data.INVENTORY_DATA[item_1]['cost'])
	
	#Item 2
	store_item_2 = item_2
	cost_2 = Data.INVENTORY_DATA[item_2]['cost']
	texture_rect_2.texture = load(Data.INVENTORY_DATA[item_2]['icon_texture'])
	label_2.text = Data.INVENTORY_DATA[item_2]['name'] + "
	Cost: " + str(Data.INVENTORY_DATA[item_2]['cost'])
	
	#Item 3
	store_item_3 = item_3
	cost_3 = Data.INVENTORY_DATA[item_3]['cost']
	texture_rect_3.texture = load(Data.INVENTORY_DATA[item_3]['icon_texture'])
	label_3.text = Data.INVENTORY_DATA[item_3]['name'] + "
	Cost: " + str(Data.INVENTORY_DATA[item_3]['cost'])


func _on_return_button_pressed() -> void:
	nevermind.emit()


func _on_more_button_1_pressed() -> void:
	quantity_item_1 += 1
	qty_label_1.text = 'QTY: ' + str(quantity_item_1)


func _on_less_button_1_pressed() -> void:
	if quantity_item_1 > 0:
		quantity_item_1 -= 1
		qty_label_1.text = 'QTY: ' + str(quantity_item_1)


func _on_more_button_2_pressed() -> void:
	quantity_item_2 += 1
	qty_label_2.text = 'QTY: ' + str(quantity_item_2)


func _on_less_button_2_pressed() -> void:
	if quantity_item_2 > 0:
		quantity_item_2 -= 1
		qty_label_2.text = 'QTY: ' + str(quantity_item_2)


func _on_more_button_3_pressed() -> void:
	quantity_item_3 += 1
	qty_label_3.text = 'QTY: ' + str(quantity_item_3)


func _on_less_button_3_pressed() -> void:
	if quantity_item_3 > 0:
		quantity_item_3 -= 1
		qty_label_3.text = 'QTY: ' + str(quantity_item_3)
