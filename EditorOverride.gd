extends Spatial

var outline = preload("res://object/Override/Outline.tscn")
var general_outline = preload("res://object/Override/GeneralOutline.tscn")

# 名前が重複しないためのカウント
var count = 0

# アウトラインの作成
func _make_outline(cube_pos : Vector3, cube_size : Vector3):
	
	# 生成されるアウトラインの情報
	var outline_list = []
	
	# 初期化
	for i in range($Highlight/Outline.get_child_count()):
		$Highlight/Outline.get_child(i).queue_free()
	
	# 縦
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y,
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y,
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y,
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y,
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	
	# 横
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y - float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y + float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y - float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y + float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	
	# 奥行
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y - float(cube_size.y),
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y - float(cube_size.y),
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y + float(cube_size.y),
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y + float(cube_size.y),
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	
	# アウトラインの生成
	for i in range(outline_list.size()):
		
		var outline_instance = outline.instance()
		
		outline_instance.translation = outline_list[i].pos
		outline_instance.rotation_degrees = outline_list[i].rot
		outline_instance.scale = outline_list[i].size
		outline_instance.name = "Outline_" + str(count)
		
		$Highlight/Outline.add_child(outline_instance)
		
		count += 1
		
# ガイド用のアウトラインの作成
func _make_general_outline(cube_pos : Vector3, cube_size : Vector3):
	
	# 生成されるアウトラインの情報
	var outline_list = []
	
	# 縦
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y,
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y,
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y,
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y,
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.y,
				0.05
			)
		}
	)
	
	# 横
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y - float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x - float(cube_size.x),
				cube_pos.y + float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y - float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(90,0,0),
			pos = Vector3(
				cube_pos.x + float(cube_size.x),
				cube_pos.y + float(cube_size.y),
				cube_pos.z
			),
			size = Vector3(
				0.05,
				cube_size.z,
				0.05
			)
		}
	)
	
	# 奥行
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y - float(cube_size.y),
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y - float(cube_size.y),
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y + float(cube_size.y),
				cube_pos.z - float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	outline_list.append(
		{
			rot = Vector3(0,0,90),
			pos = Vector3(
				cube_pos.x,
				cube_pos.y + float(cube_size.y),
				cube_pos.z + float(cube_size.z)
			),
			size = Vector3(
				0.05,
				cube_size.x,
				0.05
			)
		}
	)
	
	# アウトラインの生成
	for i in range(outline_list.size()):
		
		var outline_instance = general_outline.instance()
		
		outline_instance.translation = outline_list[i].pos
		outline_instance.rotation_degrees = outline_list[i].rot
		outline_instance.scale = outline_list[i].size
		outline_instance.name = "Outline_" + str(count)
		
		$Highlight/GeneralOutline.add_child(outline_instance)
		
		count += 1

# アウトラインの消去
func _remove_outline():
	
	# 初期化
	for i in range($Highlight/Outline.get_child_count()):
		$Highlight/Outline.get_child(i).queue_free()

# ガイド用アウトラインの消去
func _remove_general_outline():
	
	# 初期化
	for i in range($Highlight/GeneralOutline.get_child_count()):
		$Highlight/GeneralOutline.get_child(i).queue_free()
