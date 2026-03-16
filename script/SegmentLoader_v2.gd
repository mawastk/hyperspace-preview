extends Node

# セグメントローダーのv2

class_name SegmentLoaderV2

var xml = XMLParser.new()

var bitmask = [2, 3, 6, 10, 11, 14, 15, 16, 18, 19, 22, 23, 26, 27, 30, 31]

# 保持
var segment = []

# セグメントをロード
func _load_segment(path : String):
	
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
				
				var temp = {
					element = name
				}
				
				var data = {}
				
				for i in range(count):
					var arg_name = xml.get_attribute_name(i)
					var arg_value = xml.get_named_attribute_value_safe(arg_name)
					temp[arg_name] = arg_value
				
				if temp.element == "box": # ボックス
					
					data = {
						Name = "box",
						Template = "none",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Size = {x = 1.0, y = 1.0, z = 1.0},
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("size"):
						data.Size = {
							x = float(temp.size.split(" ")[0]),
							y = float(temp.size.split(" ")[1]),
							z = float(temp.size.split(" ")[2])
						}
					
					if temp.has("tile"):
						data.Tile = int(temp.tile)
					
					if temp.has("template"):
						data.Template = temp.template
					
					if temp.has("color"):
						
						var fixed = temp.color.split(" ")
						
						if fixed.size() == 1:
							
							data.Color = {r = float(fixed[0]), g = float(fixed[0]), b = float(fixed[0])}
							
						else:
							
							data.Color = {r = float(fixed[0]), g = float(fixed[1]), b = float(fixed[2])}
							
					if temp.has("tileSize"):
						
						var fixed = temp.tileSize.split(" ")
						
						if fixed.size() == 1:
							
							data.TileSize = {x = float(fixed[0]), y = float(fixed[0]), z = float(fixed[0])}
							
						else:
							
							data.TileSize = {x = float(fixed[0]), y = float(fixed[1]), z = float(fixed[2])}
					
					segment.append(data)
					
				if temp.element == "decal": # デカール
					
					data = {
						Name = "decal",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Size = {x = 1.0, y = 1.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Tile = 0
					}
					
					data["Color"] = {r = 1.0, g = 1.0, b = 1.0}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("size"):
						data.Size = {
							x = float(temp.size.split(" ")[0]),
							y = float(temp.size.split(" ")[1])
						}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					data.Tile = int(temp.tile)
					
					if temp.has("color"):
						
						var fixed = temp.color.split(" ")
						
						if fixed.size() == 1:
							
							data.Color = {r = float(fixed[0]), g = float(fixed[0]), b = float(fixed[0])}
							
						else:
							
							data.Color = {r = float(fixed[0]), g = float(fixed[1]), b = float(fixed[2])}
						
					segment.append(data)
					
				if temp.element == "powerup": # パワーアップ
					
					data = {
						Name = "powerup",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Type = "ballfernzy"
					}
					
					data["Type"] = temp.type
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					segment.append(data)
				
				if temp.element == "segment": # セグメント情報
					
					data = {
						Name = "segment",
						Size = {
							x = 12,
							y = 10,
							z = 16
						},
						Template = "basic_s"
					}
					
					if temp.has("size"):
						data.Size = {
							x = int(temp.size.split(" ")[0]),
							y = int(temp.size.split(" ")[1]),
							z = int(temp.size.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
					
					segment.append(data)
				
				if !temp.element == "obstacle": # ここからは障害物
					continue
				
				if temp.has("mode"): # クラシックモードに限定
					
					if !int(temp.mode) in bitmask:
						continue
				
				if temp.type in ["scoretop", "scorediamond", "scorestar", "scoremulti"]:
					
					var param = _param_break(temp)
					
					data = {
						Name = "scoretop",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "none",
						Raycast = false,
						Static = true
					}
					
					data.Name = temp.type
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
					
					if param.has("static"):
						data.Static = bool(param.static)
						
					if param.has("raycast"):
						data.Raycast = bool(param.raycast)
					
					segment.append(data)
				
				if temp.type == "bar":
					
					var param = _param_break(temp)
					
					data = {
						Name = "bar",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Thickness = 0.12,
						Height = 0.12,
						Move = 0,
						Speed = 1,
						Offset = 0,
						Maxwidth = 10,
						Blocker = false
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if param.has("thickness"):
						data.Thickness = float(param.thickness)
						
					if param.has("height"):
						data.Height = float(param.height)
						
					if param.has("move"):
						data.Move = float(param.move)
						
					if param.has("speed"):
						data.Speed = float(param.speed)
						
					if param.has("offset"):
						data.Offset = float(param.offset)
						
					if param.has("maxwidth"):
						data.Maxwidth = float(param.maxwidth)
						
					if param.has("blocker"):
						if str(param.blocker) == "true":
							data.Blocker = true
					
					segment.append(data)
					
				if temp.type == "sweeper":
					
					var param = _param_break(temp)
					
					data = {
						Name = "sweeper",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Width = 2,
						Height = 2,
						Panewidth = 0.4,
						Beat = false,
						Speed = 1,
						Offset = 0,
						OffsetRandom = false,
						Thickness = 0.02,
						Strength = 0.2,
						Blocker = false
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if param.has("width"):
						data.Width = float(param.width)
						
					if param.has("height"):
						data.Height = float(param.height)
						
					if param.has("panewidth"):
						data.Panewidth = float(param.panewidth)
						
					if param.has("beat"):
						if str(param.beat) == "true":
							data.Beat = true
					
					if param.has("speed"):
						data.Speed = float(param.speed)
						
					if param.has("offset"):
						data.Offset = float(param.offset)
					else:
						data.OffsetRandom = true
						
					if param.has("thickness"):
						data.Thickness = float(param.thickness)
						
					if param.has("strength"):
						data.Strength = float(param.strength)
					
					if param.has("blocker"):
						if str(param.blocker) == "blocker":
							data.Blocker = true
							
					segment.append(data)
							
				if temp.type == "foldwindow":
					
					var param = _param_break(temp)
					
					data = {
						Name = "foldwindow",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Distance = 8,
						Width = 3,
						Height = 1,
						Angle = -1.57079632679
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if temp.has("distance"):
						data.Distance = float(temp.distance)
						
					if param.has("width"):
						data.Width = float(param.width)
						
					if param.has("height"):
						data.Height = float(param.height)
						
					if param.has("angle"):
						data.Angle = float(param.angle)
					
					segment.append(data)
				
				if temp.type == "beatwindow":
					
					var param = _param_break(temp)
					
					data = {
						Name = "beatwindow",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Width = 4,
						Offset = 0,
						Beat = 2
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if param.has("width"):
						data.Width = float(param.width)
						
					if param.has("offset"):
						data.Offset = float(param.offset)
						
					if param.has("beat"):
						data.Beat = float(param.beat)
					
					segment.append(data)
					
				if temp.type == "rotor":
					
					var param = _param_break(temp)
					
					data = {
						Name = "rotor",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Length = 1,
						Width = 0.1,
						Thickness = 0.1,
						Arms = 2,
						Radius = 0.2,
						Speed = 2,
						Beat = 0,
						Offset = 0,
						OffsetRandom = true
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if param.has("length"):
						data.Length = float(param.length)
						
					if param.has("width"):
						data.Width = float(param.width)
						
					if param.has("thickness"):
						data.Thickness = float(param.thickness)
						
					if param.has("arms"):
						data.Arms = float(param.arms)
						
					if param.has("radius"):
						data.Radius = float(param.radius)
						
					if param.has("speed"):
						data.Speed = float(param.speed)
						
					if param.has("beat"):
						data.Beat = float(param.beat)
						
					if param.has("offset"):
						data.Offset = float(param.offset)
						
					if !data.Offset == 0:
						data.OffsetRandom = false
					
					segment.append(data)
					
				if temp.type == "revolver":
					
					var param = _param_break(temp)
					
					data = {
						Name = "revolver",
						Position = {x = 0.0, y = 0.0, z = 0.0},
						Rotation = {x = 0.0, y = 0.0, z = 0.0},
						Template = "basic_glass",
						Height = 2,
						Width = 3,
						Speed = 1,
						Offset = 0
					}
					
					data.Position = {
						x = float(temp.pos.split(" ")[0]),
						y = float(temp.pos.split(" ")[1]),
						z = float(temp.pos.split(" ")[2])
					}
					
					if temp.has("rot"):
						data.Rotation = {
							x = float(temp.rot.split(" ")[0]),
							y = float(temp.rot.split(" ")[1]),
							z = float(temp.rot.split(" ")[2])
						}
					
					if temp.has("template"):
						data.Template = temp.template
						
					if param.has("height"):
						data.Height = float(param.height)
						
					if param.has("width"):
						data.Width = float(param.width)
						
					if param.has("speed"):
						data.Speed = float(param.speed)
						
					if param.has("height"):
						data.Offset = float(param.offset)
					
					segment.append(data)
				
			xml.NODE_ELEMENT_END:
				end = true

# パラメーターを分解
func _param_break(temp : Dictionary):
	
	var param_list = {}
	
	for i in range(temp.keys().size()):
		if temp.keys()[i].begins_with("param"):
			
			var fixed = temp[temp.keys()[i]].split("=")
			
			param_list[fixed[0]] = fixed[1]
			
	return param_list

# 保持しているセグメントを取得
func _get_segment():
	return segment
