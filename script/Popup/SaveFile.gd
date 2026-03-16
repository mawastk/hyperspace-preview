extends Node2D

func _reset():
	
	$FileList.clear()
	
	$Save.disabled = true
	
	var file_list = HyperFile._get_file("segment",".xml.mp3")
	
	for i in range(file_list.size()):
		$FileList.add_item(" " + file_list[i])

func _on_FileName_text_changed(new_text):
	
	if new_text.length() == 0:
		
		$Save.disabled = true
		
	else:
		
		$Save.disabled = false

func _on_FileList_item_selected(index):
	var selected = $FileList.get_item_text(index).substr(1, -1).replace(".xml.mp3","")
	Sound._play("Dot")
	$FileName.text = selected
	$Save.disabled = false

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Save_button_down():
	Sound._play("Select")

func _on_Save_button_up():
	get_node("../../../")._send(self.name, "Save", $FileName.text + ".xml.mp3")
