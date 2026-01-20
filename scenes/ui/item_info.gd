extends PanelContainer

var res: ItemResource

func setup(new_res: ItemResource):
	res = new_res
	$HBoxContainer/IconTexture.texture = res.icon_texture
	$HBoxContainer/ItemLabel.text = res.name
	

func update(apple: int, wood: int):
	if res.name == "Wood":
		$HBoxContainer/CountLabel.text = str(wood)
	if res.name == "Apple":
		$HBoxContainer/CountLabel.text = str(apple)
