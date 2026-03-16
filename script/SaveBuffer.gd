extends Node

func get_data_path():
	if OS.get_name() == "Android":
		return "/storage/emulated/0/Android/data/com.mawario.hyperspace/files/"
	else:
		return "user://"
