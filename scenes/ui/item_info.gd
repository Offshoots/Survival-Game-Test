extends PanelContainer

var res: ItemResource

func setup(new_res: ItemResource):
	res = new_res
	$HBoxContainer/IconTexture.texture = res.icon_texture
	#$HBoxContainer/CountLabel.text = "1"
	$HBoxContainer/ItemLabel.text = res.name
	

func update(count: int, item_updated: Enum.Item):
	if res.name == Data.INVENTORY_DATA[item_updated]['name']:
		$HBoxContainer/CountLabel.text = str(count)
	#if res.name == "Wood":
		#$HBoxContainer/CountLabel.text = str(count)
	#if res.name == "Apple":
		#$HBoxContainer/CountLabel.text = str(count)

func remove():
	queue_free()
