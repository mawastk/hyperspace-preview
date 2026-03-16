extends Node2D

var selected = ""

func _reset():
	$Open.disabled = true
	$FileList.release_focus()
	$FileList.clear()
	
	var file_list = HyperFile._get_file("segment",".xml.mp3")
	
	for i in range(file_list.size()):
		$FileList.add_item(" " + file_list[i])

func _ready():
	var file_list = HyperFile._get_file("segment",".xml.mp3")
	
	for i in range(file_list.size()):
		$FileList.add_item(" " + file_list[i])

func _on_OpenFolder_button_down():
	Sound._play("Select")

func _on_OpenFolder_button_up():
	if OS.get_name() in ["Windows", "Android"]:
		var _rt = OS.shell_open(OS.get_user_data_dir() + "/segment")
	else:
		var _rt = OS.shell_open(HyperFile._get_path("segment"))

func _on_Open_button_down():
	get_node("../../../")._send(self.name, "Open", selected)
	Sound._play("Select")

func _on_Open_button_up():
	Sound._play("Close")

func _on_FileList_item_selected(index):
	selected = $FileList.get_item_text(index).substr(1, -1)
	Sound._play("Dot")
	$Open.disabled = false

func _on_Close_button_down():
	get_node("../../../")._close()
	Sound._play("Select")
