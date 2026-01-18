extends PanelContainer

var res: PlantResource

func setup(new_res: PlantResource):
	res = new_res
	$HBoxContainer/IconTexture.texture = res.icon_texture
	$HBoxContainer/VBoxContainer/NameLabel.text = res.name
	
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = res.h_frames
	$HBoxContainer/VBoxContainer/GrowthBar.value = res.age
	$HBoxContainer/VBoxContainer/DeathBar.max_value = res.death_max
	$HBoxContainer/VBoxContainer/DeathBar.value = res.death_count
	
	#This connect function is linked to any changed death update. 
	res.connect("changed", death_checker)

func update():
	$HBoxContainer/VBoxContainer/GrowthBar.value = res.age
	$HBoxContainer/VBoxContainer/DeathBar.value = res.death_count

#Removes the plant info container when a plant dies or is collected
func death_checker():
	queue_free()
