extends Control

#This add function will add the "Plant_info" as a child inside the Vbox container
func add(plant_info: PanelContainer):
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(plant_info)

#Upade all the plant info in the vbox container
func update_all():
	for plant_info in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		plant_info.update()
	
