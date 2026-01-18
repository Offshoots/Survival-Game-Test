extends PanelContainer

var res: MapResource

func setup(new_res: MapResource):
	res = new_res
	$HBoxContainer/IconTexture.texture = res.icon_texture
	$HBoxContainer/ItemLabel.text = res.name
	
