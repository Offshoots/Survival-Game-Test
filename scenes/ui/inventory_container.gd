extends Control


#This add function will add the "Item_info" as a child inside the Vbox container
func add(item_info: PanelContainer):
		$MarginContainer/VBoxContainer.add_child(item_info)

#Upade all the item info in the vbox container
func update_all(count: int, item_updated: Enum.Item):
	for item_info in $MarginContainer/VBoxContainer.get_children():
			item_info.update(count, item_updated)
			var count_label = item_info.get_node("HBoxContainer/CountLabel").text
			#print(count)
			if int(count_label) < 1:
				item_info.remove()
				break
