extends PanelContainer

var res: ItemResource

func setup(new_res: ItemResource):
	res = new_res
	$HBoxContainer/IconTexture.texture = res.icon_texture
	$HBoxContainer/ItemLabel.text = res.name

func update(count: int, item_updated: Enum.Item):
	if res.name == Data.INVENTORY_DATA[item_updated]['name']:
		$HBoxContainer/CountLabel.text = str(count) + " "

func remove():
	queue_free()
