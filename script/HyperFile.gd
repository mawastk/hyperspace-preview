extends Node

var dir = Directory.new()

func _ready():
	if dir.dir_exists(SaveBuffer.get_data_path() + "segment") == false:
		dir.open(SaveBuffer.get_data_path())
		dir.make_dir("segment")

func _get_path(path : String):
	return SaveBuffer.get_data_path() + path

func _get_file(path : String, ext : String):
	dir.open(_get_path(path))
	dir.list_dir_begin()
	var file_list = []
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with(".") and file.ends_with(ext):
			file_list.append(file)
	return file_list
