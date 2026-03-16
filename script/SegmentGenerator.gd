extends Node

class_name SegmentGenerator

func _generate_segment(data : Array, info : Dictionary):
	
	var segment_data = data
	var segment_xml = ""
	
	# ヘッダーの設定
	
	segment_xml += "<!-- export in Hyperspace -->\n\n"
	
	if info.autosize == false:
		segment_xml += "<segment size=\"" + str(info.size.x) + " " + str(info.size.y) + " " + str(info.size.z)
	else:
		segment_xml += "<segment size=\"" + str(info.size.x) + " " + str(info.size.y) + " " + str(info.auto_z)
		
	segment_xml += "\" template=\"" + info.template + "\">\n"
	
	# セグメントデータを元に生成
	
	for i in range(segment_data.size()):
		
		var segment_line = ""
		var detected = false
		
		match segment_data[i].Name:
			
			"box": # ボックス
				
				if segment_data[i].has("Remove"):
					continue
				
				var position = segment_data[i].Position
				var size = segment_data[i].Size
				var template = null
				var reflection = "0"
				
				if segment_data[i].has("Template"):
					template = segment_data[i].Template
					
				segment_line += "<box size=\"" + str(size.x) + " " + str(size.y) + " " + str(size.z) + "\" "
				segment_line += "pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
				
				if TemplateManager._get_template("tile", template).reflection == true:
					reflection = "1"
				
				if !template == null:
					segment_line += "hidden=\"0\" "
					segment_line += "template=\"" + template + "\" "
					
				if segment_data[i].has("Tile"):
					segment_line += "tile=\"" + str(segment_data[i].Tile) + "\" "
					
				if segment_data[i].has("Color"):
					segment_line += "color=\"" + str(segment_data[i].Color.r) + " " + str(segment_data[i].Color.g) + " " + str(segment_data[i].Color.b) + "\" "
				
				if segment_data[i].has("TileSize"):
					segment_line += "tileSize=\"" + str(segment_data[i].TileSize.x) + " " + str(segment_data[i].TileSize.y) + " " + str(segment_data[i].TileSize.z) + "\" "
					
				if !template == null:
					segment_line += "reflection=\"" + reflection + "\"/>"
				else:
					segment_line += "hidden=\"0\"/>"
				detected = true
				
			"decal": # デカール
				
				if segment_data[i].has("Remove"):
					continue
				
				var position = segment_data[i].Position
				var rotate = {}
				
				if segment_data[i].has("Rotation"):
					rotate = segment_data[i].Rotation
				
				var size = Vector2(1,1)
				
				if segment_data[i].has("Size"):
					size = segment_data[i].Size
				
				var tile = segment_data[i].Tile
				var color = {}
				
				if segment_data[i].has("Color"):
					color = segment_data[i].Color
				
				segment_line += "<decal pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
				if rotate.has("x"):
					segment_line += "rot=\"" + str(rotate.x) + " " + str(rotate.y) + " " + str(rotate.z) + "\" "
				segment_line += "tile=\"" + str(tile) + "\" "
				segment_line += "size=\"" + str(size.x) + " " + str(size.y) + "\" "
				if color.has("r"):
					segment_line += "color=\"" + str(color.r) + " " + str(color.g) + " " + str(color.b) + "\" "
				segment_line += "hidden=\"0\"/>"
				
				detected = true
				
			"powerup": # パワーアップ
				
				if segment_data[i].has("Remove"):
					continue
				
				var position = segment_data[i].Position
				var type = segment_data[i].Type
				
				
				segment_line += "<powerup pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
				segment_line += "type=\"" + type + "\" "
				segment_line += "hidden=\"0\"/>"
				
				detected = true
		
		if segment_data[i].Name.begins_with("score"): # クリスタル
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var raycast = segment_data[i].Raycast
			var static_param = segment_data[i].Static
			
			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			if raycast == true:
				segment_line += "param1=\"raycast=true\" "
			
			if segment_data[i].Name == "scoretop":
				
				if static_param == true:
					segment_line += "param2=\"static=true\" "
				elif static_param == false:
					segment_line += "param2=\"static=false\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
			
		if segment_data[i].Name == "bar": # バー（棒）
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var height = segment_data[i].Height
			var thickness = segment_data[i].Thickness
			var maxwidth = segment_data[i].Maxwidth
			var move = segment_data[i].Move
			var speed = segment_data[i].Speed
			var offset = segment_data[i].Offset
			var blocker = segment_data[i].Blocker
			
			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"height=" + str(height) + "\" "
			
			segment_line += "param2=\"thickness=" + str(thickness) + "\" "
			
			segment_line += "param3=\"maxwidth=" + str(maxwidth) + "\" "
			
			segment_line += "param4=\"move=" + str(move) + "\" "
			
			segment_line += "param5=\"speed=" + str(speed) + "\" "
			
			segment_line += "param6=\"offset=" + str(offset) + "\" "
			
			segment_line += "param7=\"blocker=" + str(blocker).to_lower() + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
			
		if segment_data[i].Name == "sweeper": # スイーパー
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var panewidth = segment_data[i].Panewidth
			var height = segment_data[i].Height
			var thickness = segment_data[i].Thickness
			var width = segment_data[i].Width
			var speed = segment_data[i].Speed
			var offset = segment_data[i].Offset
			var beat = segment_data[i].Beat
			var offsetrandom = segment_data[i].OffsetRandom
			
			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"panewidth=" + str(panewidth) + "\" "
			
			segment_line += "param2=\"height=" + str(height) + "\" "
			
			segment_line += "param3=\"thickness=" + str(thickness) + "\" "
			
			segment_line += "param4=\"width=" + str(width) + "\" "
			
			segment_line += "param5=\"speed=" + str(speed) + "\" "
			
			segment_line += "param6=\"beat=" + str(beat).to_lower() + "\" "
			
			if offsetrandom == false:
				segment_line += "param7=\"offset=" + str(offset) + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
			
		if segment_data[i].Name == "foldwindow": # 折り畳み
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var width = segment_data[i].Width
			var height = segment_data[i].Height
			var distance = segment_data[i].Distance
			var angle = segment_data[i].Angle
			
			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"width=" + str(width) + "\" "
			
			segment_line += "param2=\"height=" + str(height) + "\" "
			
			segment_line += "param3=\"distance=" + str(distance) + "\" "
			
			segment_line += "param4=\"angle=" + str(angle) + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
			
		if segment_data[i].Name == "beatwindow": # 折り畳み（ビート）
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var width = segment_data[i].Width
			var beat = segment_data[i].Beat
			var offset = segment_data[i].Offset

			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"width=" + str(width) + "\" "
			
			segment_line += "param2=\"beat=" + str(beat) + "\" "
			
			segment_line += "param3=\"offset=" + str(offset) + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
	
		if segment_data[i].Name == "rotor": # プロペラ
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var width = segment_data[i].Width
			var length = segment_data[i].Length
			var thickness = segment_data[i].Thickness
			var beat = segment_data[i].Beat
			var speed = segment_data[i].Speed
			var offset = segment_data[i].Offset
			var arms = segment_data[i].Arms
			var radius = segment_data[i].Radius

			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"width=" + str(width) + "\" "
			
			segment_line += "param2=\"length=" + str(length) + "\" "
			
			segment_line += "param3=\"thickness=" + str(thickness) + "\" "
			
			segment_line += "param4=\"beat=" + str(beat) + "\" "
			
			segment_line += "param5=\"speed=" + str(speed) + "\" "
			
			segment_line += "param6=\"offset=" + str(offset) + "\" "
			
			segment_line += "param7=\"arms=" + str(arms) + "\" "
			
			segment_line += "param8=\"radius=" + str(radius) + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
		
		if segment_data[i].Name == "revolver": # リボルバー
			
			if segment_data[i].has("Remove"):
				continue
			
			var position = segment_data[i].Position
			var rotation = segment_data[i].Rotation
			var template = segment_data[i].Template
			var width = segment_data[i].Width
			var height = segment_data[i].Height
			var speed = segment_data[i].Speed
			var offset = segment_data[i].Offset

			segment_line += "<obstacle pos=\"" + str(position.x) + " " + str(position.y) + " " + str(position.z) + "\" "
			
			segment_line += "rot=\"" + str(rotation.x) + " " + str(rotation.y) + " " + str(rotation.z) + "\" "
			
			segment_line += "type=\"" + segment_data[i].Name + "\" "
			segment_line += "template=\"" + template + "\" "
			
			segment_line += "param1=\"width=" + str(width) + "\" "
			
			segment_line += "param2=\"height=" + str(height) + "\" "
			
			segment_line += "param3=\"speed=" + str(speed) + "\" "
			
			segment_line += "param4=\"offset=" + str(offset) + "\" "
			
			segment_line += "hidden=\"0\"/>"
			
			detected = true
			
		if detected == true:
			segment_xml += "\t" + segment_line + "\n"
	segment_xml += "</segment>"
	
	return segment_xml
