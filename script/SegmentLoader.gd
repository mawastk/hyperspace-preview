extends Node

# 使われなくなった旧バージョンのセグメントローダーです
# 現在はSegmentLoaderV2が使用されています

class_name SegmentLoader

var xml = XMLParser.new()

var segment = []

func _load_segment(path : String):
	var segment_data = []
	var end = false
	segment = []
	if !xml.open(path) == OK:
		return
	while end == false:
		if xml.read() != OK:
			return
		var type = xml.get_node_type()
		var name = xml.get_node_name()
		match type:
			xml.NODE_ELEMENT:
				var count = xml.get_attribute_count()
				var detected = false
				var data = {
					Name = name
				}
				for i in range(count):
					var arg_name = xml.get_attribute_name(i)
					var arg_value = xml.get_named_attribute_value_safe(arg_name)
					match name:
						"segment":
							match arg_name:
								"size":
									var arg_fixed = arg_value.split(" ")
									data["Size"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"template":
									data["Template"] = arg_value
									detected = true
						"box":
							match arg_name:
								"size":
									var arg_fixed = arg_value.split(" ")
									data["Size"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"pos":
									var arg_fixed = arg_value.split(" ")
									data["Position"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"tile":
									var arg_fixed = arg_value.split(" ")
									data["Tile"] = int(arg_fixed[0])
									detected = true
								"color":
									var arg_fixed = arg_value.split(" ")
									if arg_fixed.size() == 1:
										data["Color"] = {
											r = float(arg_fixed[0]),
											g = float(arg_fixed[0]),
											b = float(arg_fixed[0])
										}
									else:
										data["Color"] = {
											r = float(arg_fixed[0]),
											g = float(arg_fixed[1]),
											b = float(arg_fixed[2])
										}
									detected = true
								"tileSize":
									var arg_fixed = arg_value.split(" ")
									if arg_fixed.size() == 1:
										data["TileSize"] = {
											x = int(arg_fixed[0]),
											y = int(arg_fixed[0]),
											z = int(arg_fixed[0])
										}
									else:
										data["TileSize"] = {
											x = int(arg_fixed[0]),
											y = int(arg_fixed[1]),
											z = int(arg_fixed[2])
										}
									detected = true
								"template":
									data["Template"] = arg_value
									detected = true
						"powerup":
							match arg_name:
								"pos":
									var arg_fixed = arg_value.split(" ")
									data["Position"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"type":
									data["Type"] = arg_value
									detected = true
						"decal":
							match arg_name:
								"pos":
									var arg_fixed = arg_value.split(" ")
									data["Position"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"size":
									var arg_fixed = arg_value.split(" ")
									data["Size"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1])
									}
								"rot":
									var arg_fixed = arg_value.split(" ")
									data["Rotation"] = {
										x = float(arg_fixed[0]),
										y = float(arg_fixed[1]),
										z = float(arg_fixed[2])
									}
									detected = true
								"color":
									var arg_fixed = arg_value.split(" ")
									data["Color"] = {
										r = float(arg_fixed[0]),
										g = float(arg_fixed[1]),
										b = float(arg_fixed[2])
									}
									detected = true
								"tile":
									data["Tile"] = int(arg_value)
									detected = true
				if detected == true:
					segment_data.append(data)
			xml.NODE_ELEMENT_END:
				end = true
	segment = segment_data

func _get_segment():
	return segment
