extends Spatial

var file = File.new()

# セグメント読み込み/エクスポート用スクリプト
var segmentloader = SegmentLoaderV2.new()
var segmentgenerator = SegmentGenerator.new()
var segmentcompressor = SegmentCompressor.new()

# リアルタイムセグメントデータ
var segment = []
var segment_info = {
	size = {
		x = 12,
		y = 10,
		z = 16
	},
	template = "basic_s",
	autosize = false,
	auto_z = 0
}
var object_count = -1

# カメラ
var sensitivity = 0.2
var smooth = 20
var move_speed = 2
var verticle_speed = 1.5
var dash = 1
var mobile = false

# 編集
var selected = 0
var focus = false
var check = false
var preview = false
var snap = false
var scaling = false
var firstpos = Vector3.ZERO
var firstsize = Vector3.ZERO

# 雑な処理
var resize_snap = Vector3.ZERO
var resize_recent = ""
var block_gizmo = false

func _ready():
	
	# テンプレートの初期化 / 読み込み
	TemplateManager._load_template()

func _physics_process(_delta):
	
	# カメラ移動
	
	if get_node("%Inspector").active == false:
		if Input.is_action_pressed("Up"):
			mobile = false
			$Camera.up = true
		else:
			if mobile == false:
				$Camera.up = false
			
		if Input.is_action_pressed("Down"):
			mobile = false
			$Camera.down = true
		else:
			if mobile == false:
				$Camera.down = false
			
		if Input.is_action_pressed("Left"):
			mobile = false
			$Camera.left = true
		else:
			if mobile == false:
				$Camera.left = false
			
		if Input.is_action_pressed("Right"):
			mobile = false
			$Camera.right = true
		else:
			if mobile == false:
				$Camera.right = false
			
		if Input.is_action_pressed("Space"):
			mobile = false
			$Camera.space = true
		else:
			if mobile == false:
				$Camera.space = false
			
		if Input.is_action_pressed("Fall"):
			mobile = false
			$Camera.fall = true
		else:
			if mobile == false:
				$Camera.fall = false
	
	$Override/Grid/Grid.translation.x = floor($Camera.translation.x)
	$Override/Grid/Grid.translation.z = floor($Camera.translation.z)
	
	$Override/Grid/SegmentSize.translation.z = segment_info.size.z * -1

func _update_autosize():
	
	var segmentsize = 0
	
	for i in range(segment.size()):
		
		if segment[i].Name == "box":
			if segmentsize > segment[i].Position.z - ceil(segment[i].Size.z / 2):
				segmentsize = ceil(segment[i].Position.z - ceil(segment[i].Size.z / 2)) - 1
	
	segment_info.auto_z = abs(segmentsize)
	
	$Override/Grid/AutoSegsize.translation.z = segmentsize
	
	if $Override/Grid/AutoSegsize.translation.z == $Override/Grid/Axis.translation.z:
		$Override/Grid/AutoSegsize.hide()
	else:
		$Override/Grid/AutoSegsize.show()

func _reset_segment():
	
	if $Object/Box.get_child_count() > 0:
		for i in range($Object/Box.get_child_count()):
			$Object/Box.get_child(i).queue_free()
			
	if $Object/Decal.get_child_count() > 0:
		for i in range($Object/Decal.get_child_count()):
			$Object/Decal.get_child(i).queue_free()
			
	if $Object/Powerup.get_child_count() > 0:
		for i in range($Object/Powerup.get_child_count()):
			$Object/Powerup.get_child(i).queue_free()
			
	if $Object/Score.get_child_count() > 0:
		for i in range($Object/Score.get_child_count()):
			$Object/Score.get_child(i).queue_free()
			
	if $Object/Obstacle.get_child_count() > 0:
		for i in range($Object/Obstacle.get_child_count()):
			$Object/Obstacle.get_child(i).queue_free()
	
	get_node("%Override")._remove_general_outline()
	get_node("%Override")._remove_outline()
	
	$Override/Gizmo.hide()
	
	selected = 0
	focus = false
	
	segment_info = {
		size = {
			x = 12,
			y = 10,
			z = 16
		},
		template = "basic_s",
		autosize = false
	}
	object_count = -1

func _fix_segment():
	
	# セグメントの修復
	
	var error = Error.new()
	
	for i in range(segment.size()):
		
		if segment[i].Name == "box": # ボックス
			
			if !segment[i].has("Template"):
				segment[i].Template = "none"
				error._add_error("NoTemplateBox")
				
			if !segment[i].has("Position"):
				segment[i].Position = {
					x = 0,
					y = 0,
					z = 0
				}
				error._add_error("NoPositionBox")
				
			if !segment[i].has("Size"):
				segment[i].Size = {
					x = 1,
					y = 1,
					z = 1
				}
				error._add_error("NoSizeBox")
				
		if segment[i].Name == "decal": # デカール
				
			if !segment[i].has("Size"):
				segment[i].Size = {
					x = 1,
					y = 1
				}
				
			if !segment[i].has("Rotation"):
				segment[i].Rotation = {
					x = 0,
					y = 0,
					z = 0
				}
				
		if segment[i].Name == "powerup": # パワーアップ
				
			if !segment[i].has("Position"):
				segment[i].Position = {
					x = 0,
					y = 0,
					z = 0
				}
				error._add_error("NoPositionPowerup")
			
			if !segment[i].has("Type"):
				segment[i].Type = "ballfrenzy"
				error._add_error("NoTypePowerup")
				
			elif !segment[i].Type in ["ballfrenzy", "nitroballs", "slowmotion", "extraball", "multiball"]:
				segment[i].Type = "ballfrenzy"
				error._add_error("NoTypePowerup")
			
	# エラーがあった場合はポップアップ
	
	if !error.error.size() == 0:
		GlobalPopup._pop("SegmentError", error.error)

func _make_segment():
	
	# セグメントの初期化と修復
	
	_reset_segment()
	_fix_segment()
	
	# 消去を待つ
	
	yield(get_tree(), "idle_frame")
	
	# セグメントの構築（エディター側の表示）
	
	for i in range(segment.size()):
		
		if segment[i].Name == "box": # ボックス
			
			var box_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Box.add_child(box_instance)
			
			# アウトライン作成
			
			get_node("%Override")._make_general_outline(box_instance.translation, box_instance.scale)
			
			object_count = i
			
		if segment[i].Name == "decal": # デカール
			
			var decal_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Decal.add_child(decal_instance)
			
			object_count = i
			
		if segment[i].Name == "powerup": # パワーアップ
			
			var powerup_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Powerup.add_child(powerup_instance)
			
			get_node("%Override")._make_general_outline(powerup_instance.translation, powerup_instance.scale)
			
			object_count = i
		
		if segment[i].Name.begins_with("score"): # クリスタル
			
			var score_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Score.add_child(score_instance)
			
			object_count = i
			
		if segment[i].Name == "bar": # バー（横棒）
			
			var bar_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(bar_instance)
			
			object_count = i
			
		if segment[i].Name == "sweeper": # スイーパー
			
			var sweeper_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(sweeper_instance)
			
			object_count = i
		
		if segment[i].Name == "foldwindow": # 折り畳み
			
			var foldwindow_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(foldwindow_instance)
			
			object_count = i
			
		if segment[i].Name == "beatwindow": # 折り畳み（ビート）
			
			var beatwindow_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(beatwindow_instance)
			
			object_count = i
	
		if segment[i].Name == "rotor": # プロペラ
			
			var rotor_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(rotor_instance)
			
			object_count = i
		
		if segment[i].Name == "revolver": # リボルバー
			
			var revolver_instance = ObjectGenerator._make_object(segment[i], i)
			
			$Object/Obstacle.add_child(revolver_instance)
			
			object_count = i
		
		if segment[i].Name == "segment": # セグメント情報

		
			$Override/Guide.translation.z = float(segment[i].Size.z / 2) * -1
			$Override/Grid/SegmentSize.translation.z = segment[i].Size.z * -1
			
			if segment[i].has("Template"):
				
				segment_info.size.x = segment[i].Size.x
				segment_info.size.y = segment[i].Size.y
				segment_info.size.z = segment[i].Size.z
				segment_info.template = segment[i].Template
			
			object_count = i
	
	# 呼び出す前に待つ
	yield(get_tree(), "idle_frame")
	
	# 一部のオブジェクトの最終処理
	get_tree().call_group("Obstacle","_final")
	
	_update_autosize()

# セグメント内のオブジェクトを取得
func _get_object(idx : int):
	return segment[idx]

# セグメント内のオブジェクトを編集
func _set_object(idx : int, key : String, value, inspector = true):
	
	segment[idx][key] = value
	
	if focus == true:
		
		if segment[idx].Name == "box":
		
			var pos = Vector3(
				segment[idx].Position.x,
				segment[idx].Position.y,
				segment[idx].Position.z
			)
			
			$Override._remove_outline()
			$Override._make_outline(
				pos,
				Vector3(
					segment[idx].Size.x,
					segment[idx].Size.y,
					segment[idx].Size.z
				)
			)
		
		elif segment[idx].Name == "decal":
			
			var pos = Vector3(
				segment[idx].Position.x,
				segment[idx].Position.y,
				segment[idx].Position.z
			)
	
		elif segment[idx].Name == "powerup":
			
			var pos = Vector3(
				segment[idx].Position.x,
				segment[idx].Position.y,
				segment[idx].Position.z
			)
	
	if inspector == true:
		$Inspector/Inspector._update(segment[idx], idx)

# オブジェクトを追加
func _add_object(type : String, pos : Vector3):
	
	if type == "box": # ボックス
		
		object_count += 1
		
		segment.append(
			{
				Name = "box",
				Position = {
					x = pos.x,
					y = pos.y,
					z = pos.z
				},
				Size = {
					x = 0.5,
					y = 0.5,
					z = 0.5
				},
				Template = "None"
			}
		)
		
		$Object/Box.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "decal": # デカール
		
		object_count += 1
		
		segment.append(
			{
				Name = "decal",
				Position = {
					x = pos.x,
					y = pos.y,
					z = pos.z
				},
				Size = {
					x = 1,
					y = 1
				},
				Rotation = {
					x = 0,
					y = 0,
					z = 0
				},
				Tile = 0,
				Template = "None"
			}
		)
		
		$Object/Decal.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
		
	if type == "powerup": # パワーアップ
		
		object_count += 1
		
		segment.append(
			{
				Name = "powerup",
				Position = {
					x = pos.x,
					y = pos.y,
					z = pos.z
				},
				Type = "ballfrenzy"
			}
		)
		
		$Object/Powerup.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type.begins_with("score"): # クリスタル
		
		object_count += 1
		
		segment.append(
			{
				Name = "scoretop",
				Position = {
					x = pos.x,
					y = pos.y,
					z = pos.z
				},
				Rotation = {
					x = 0,
					y = 0,
					z = 0
				},
				Template = "basic_st",
				Raycast = false,
				Static = true
			}
		)
		
		$Object/Score.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "bar": # バー（棒）
		
		object_count += 1
		
		segment.append(
			{
				Name = "bar",
				Position = {x = pos.x, y = pos.y, z = pos.z},
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
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
		
	if type == "sweeper": # スイーパー
		
		object_count += 1
		
		segment.append(
			{
				Name = "sweeper",
				Position = {x = pos.x, y = pos.y, z = pos.z},
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
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "foldwindow": # 折り畳み
		
		object_count += 1
		
		segment.append(
			{
				Name = "foldwindow",
				Position = {x = pos.x, y = pos.y, z = pos.z},
				Rotation = {x = 0.0, y = 0.0, z = 0.0},
				Template = "basic_glass",
				Width = 3,
				Height = 1,
				Distance = 8,
				Angle = -1.57079632679
			}
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "beatwindow": # 折り畳み（ビート）
		
		object_count += 1
		
		segment.append(
			{
				Name = "beatwindow",
				Position = {x = pos.x, y = pos.y, z = pos.z},
				Rotation = {x = 0.0, y = 0.0, z = 0.0},
				Template = "basic_glass",
				Width = 4,
				Offset = 0,
				Beat = 2
			}
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "rotor": # プロペラ
		
		object_count += 1
		
		segment.append(
			{
				Name = "rotor",
				Position = {x = pos.x, y = pos.y, z = pos.z},
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
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))
	
	if type == "revolver": # リボルバー
		
		object_count += 1
		
		segment.append(
			{
				Name = "revolver",
				Position = {x = pos.x, y = pos.y, z = pos.z},
				Rotation = {x = 0.0, y = 0.0, z = 0.0},
				Template = "basic_glass",
				Height = 2,
				Width = 3,
				Speed = 1,
				Offset = 0
			}
		)
		
		$Object/Obstacle.add_child(ObjectGenerator._make_object(segment[object_count], object_count))

# オブジェクトを消去する時の処理
func _remove_object(idx : int):
	
	var object = segment[idx]
	
	focus = false
	
	if object.Name == "box": # ボックス
		
		get_node("%Override")._remove_outline()
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Box.get_node("Box_" + str(idx)).queue_free()
	
	elif object.Name == "decal": # デカール
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Decal.get_node("Decal_" + str(idx)).queue_free()
		
	elif object.Name == "powerup": # パワーアップ
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Powerup.get_node("Powerup_" + str(idx)).queue_free()
		
	elif object.Name.begins_with("score"): # クリスタル
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Score.get_node("Score_" + str(idx)).queue_free()
		
	elif object.Name == "bar": # バー（棒）
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Bar_" + str(idx)).queue_free()
		
	elif object.Name == "sweeper": # スイーパー
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Sweeper_" + str(idx)).queue_free()
		
	elif object.Name == "foldwindow": # 折り畳み
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Foldwindow_" + str(idx)).queue_free()
		
	elif object.Name == "beatwindow": # 折り畳み（ビート）
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Beatwindow_" + str(idx)).queue_free()
		
	elif object.Name == "rotor": # プロペラ
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Rotor_" + str(idx)).queue_free()
		
	elif object.Name == "revolver": # リボルバー
		
		segment[idx].Remove = true
		
		$Override/Gizmo.hide()
		$Object/Obstacle.get_node("Revolver_" + str(idx)).queue_free()

# オブジェクトを複製する時の処理
func _duplicate_object():
	
	var object = _get_object(selected)
	
	_add_object(
		object.Name,
		Vector3(
			object.Position.x,
			object.Position.y,
			object.Position.z
		)
	)
	
	segment[object_count] = Dictionary(object).duplicate(true)
	
	_sync_object(object_count)

func _clear_object(idx : int, key : String, inspector):
	
	segment[idx].erase(key)
	
	if inspector == true:
		$Inspector/Inspector._update(segment[idx], idx)

# セグメント内のオブジェクトと同期
func _sync_object(idx : int):
	
	var object = segment[idx]
	
	if object.Name == "box": # ボックス
		
		var box = $Object/Box.get_node("Box_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var size = Vector3(1, 1, 1)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Size"):
			size = Vector3(
				object.Size.x,
				object.Size.y,
				object.Size.z
			)
		
		box.translation = position
		box.scale = size
		
		var template = TemplateManager._get_template("tile", object.Template)
		
		if template.texture.size() == 1:
			
			if object.has("Tile"):
				
				box._set_texture(object.Tile)
			
			else:
			
				box._set_texture(template.texture[0])
		else:
			
			if object.has("Tile"):
				
				box._set_texture(object.Tile)
			
			else:
			
				box._set_texture(template.texture[0], template.texture[1], template.texture[2])
		
		if template.has("size"):
			if template.size.size() == 1:
				box._set_tilesize(template.size[0])
			else:
				box._set_tilesize(template.size[0], template.size[1], template.size[2])
		else:
			box._set_tilesize(1)
		
		if object.has("TileSize"):
			
			box._set_tilesize(
				object.TileSize.x,
				object.TileSize.y,
				object.TileSize.z
			)
			
		if template.modulate.size() == 3:
			box._set_color(
				Color(
					template.modulate[0],
					template.modulate[1],
					template.modulate[2]
				)
			)
		else:
			box._set_color(
				Color(
					template.modulate[0],
					template.modulate[1],
					template.modulate[2]
				),
				Color(
					template.modulate[3],
					template.modulate[4],
					template.modulate[5]
				),
				Color(
					template.modulate[6],
					template.modulate[7],
					template.modulate[8]
				)
			)
		
		if object.has("Color"):
			
			box._set_color(Color(
				object.Color.r,
				object.Color.g,
				object.Color.b
			))
		
		box._update_uv()
		
		$Override/Gizmo.translation = position
	
	elif object.Name == "decal": # デカール
	
		var decal = $Object/Decal.get_node("Decal_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var size = Vector3(1, 1, 1)
		var rot = Vector3(0, 0, 0)
		var color = Color(1.0, 1.0, 1.0)
		var tile = 0
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Size"):
			size = Vector3(
				object.Size.x,
				object.Size.y,
				1
			)
			
		if object.has("Rotation"):
			rot = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
			
		if object.has("Color"):
			color = Color(
				object.Color.r,
				object.Color.g,
				object.Color.b
			)
		
		if object.has("Tile"):
			tile = object.Tile
		
		decal.translation = position
		decal._scale(size)
		decal._rotation(rot)
		decal._color(color)
		decal._tile(tile)
		
		$Override/Gizmo.translation = position
	
	elif object.Name == "powerup": # パワーアップ
		
		var powerup = $Object/Powerup.get_node("Powerup_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var type = "ballfrenzy"
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Type"):
			type = object.Type
		
		powerup.translation = position
		
		powerup.type = type
		powerup._type(type)
		
		$Override/Gizmo.translation = position
	
	elif object.Name.begins_with("score"): # クリスタル
	
		var score = $Object/Score.get_node("Score_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		score.translation = position
		score.rotation = rotate
		
		score._type(object.Name)
		score._template(object.Template)
		
		$Override/Gizmo.translation = position
		
	elif object.Name == "bar": # バー（棒）
	
		var bar = $Object/Obstacle.get_node("Bar_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			bar.template = object.Template
		
		if object.has("Height"):
			bar.height = object.Height
			
		if object.has("Thickness"):
			bar.thickness = object.Thickness
			
		if object.has("Maxwidth"):
			bar.maxwidth = object.Maxwidth
			
		if object.has("Move"):
			bar.move = object.Move
			
		if object.has("Speed"):
			bar.speed = object.Speed
			
		if object.has("Offset"):
			bar.offset = object.Offset
			
		if object.has("Blocker"):
			bar.blocker = object.Blocker
		
		bar.translation = position
		bar.rotation = rotate
		
		bar._update(true)
		
		$Override/Gizmo.translation = position
		
	elif object.Name == "sweeper": # スイーパー
	
		var sweeper = $Object/Obstacle.get_node("Sweeper_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			sweeper.template = object.Template
			
		if object.has("Panewidth"):
			sweeper.panewidth = object.Panewidth
		
		if object.has("Height"):
			sweeper.height = object.Height
			
		if object.has("Thickness"):
			sweeper.thickness = object.Thickness
			
		if object.has("Width"):
			sweeper.width = object.Width
			
		if object.has("Speed"):
			sweeper.speed = object.Speed
			
		if object.has("Offset"):
			sweeper.offset = object.Offset
			
		if object.has("R"):
			sweeper.offset_random = object.OffsetRandom
			
		if object.has("Beat"):
			sweeper.beat = object.Beat
			
		if object.has("OffsetRandom"):
			sweeper.offset_random = object.OffsetRandom
		
		sweeper.translation = position
		sweeper.rotation = rotate
		
		sweeper._update()
		
		$Override/Gizmo.translation = position
		
	elif object.Name == "foldwindow": # 折り畳み
	
		var foldwindow = $Object/Obstacle.get_node("Foldwindow_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			foldwindow.template = object.Template
		
		if object.has("Height"):
			foldwindow.height = object.Height
			
		if object.has("Width"):
			foldwindow.width = object.Width
			
		if object.has("Distance"):
			foldwindow.distance = object.Distance
			
		if object.has("Angle"):
			foldwindow.angle = object.Angle
		
		foldwindow.translation = position
		foldwindow.rotation = rotate
		
		foldwindow._update()
		
		$Override/Gizmo.translation = position

	elif object.Name == "beatwindow": # 折り畳み（ビート）
	
		var beatwindow = $Object/Obstacle.get_node("Beatwindow_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			beatwindow.template = object.Template
			
		if object.has("Width"):
			beatwindow.width = object.Width
			
		if object.has("Beat"):
			beatwindow.beat = object.Beat
			
		if object.has("Offset"):
			beatwindow.offset = object.Offset
		
		beatwindow.translation = position
		beatwindow.rotation = rotate
		
		beatwindow._update()
		
		$Override/Gizmo.translation = position
	
	elif object.Name == "rotor": # プロペラ
	
		var rotor = $Object/Obstacle.get_node("Rotor_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			rotor.template = object.Template
			
		if object.has("Length"):
			rotor.length = object.Length
			
		if object.has("Width"):
			rotor.width = object.Width
			
		if object.has("Thickness"):
			rotor.thickness = object.Thickness
			
		if object.has("Arms"):
			rotor.arms = object.Arms
			
		if object.has("Radius"):
			rotor.radius = object.Radius
			
		if object.has("Beat"):
			rotor.beat = object.Beat
			
		if object.has("Offset"):
			rotor.offset = object.Offset
			
			if object.Offset == 0:
				rotor.offset_random = true
			else:
				rotor.offset_random = false
		
		rotor.translation = position
		rotor.rotation = rotate
		
		rotor._update()
		
		$Override/Gizmo.translation = position
	
	elif object.Name == "revolver": # リボルバー
	
		var revolver = $Object/Obstacle.get_node("Revolver_" + str(idx))
		
		var position = Vector3(0, 0, 0)
		var rotate = Vector3(0, 0, 0)
		
		if object.has("Position"):
			position = Vector3(
				object.Position.x,
				object.Position.y,
				object.Position.z
			)
			
		if object.has("Rotation"):
			rotate = Vector3(
				object.Rotation.x,
				object.Rotation.y,
				object.Rotation.z
			)
		
		if object.has("Template"):
			revolver.template = object.Template
			
		if object.has("Width"):
			revolver.width = object.Width
			
		if object.has("Height"):
			revolver.height = object.Height
			
		if object.has("Speed"):
			revolver.speed = object.Speed
			
		if object.has("Offset"):
			revolver.offset = object.Offset
		
		revolver.translation = position
		revolver.rotation = rotate
		
		revolver._update()
		
		$Override/Gizmo.translation = position

# ボックスが選択された時の処理
func _box_selected(idx : int):
	
	if block_gizmo == true:
		return
	
	get_node("%Override")._make_outline(
		Vector3(
			_get_object(idx).Position.x,
			_get_object(idx).Position.y,
			_get_object(idx).Position.z
		),
		Vector3(
			_get_object(idx).Size.x,
			_get_object(idx).Size.y,
			_get_object(idx).Size.z
		)
	)
	
	$Override/Gizmo.translation = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	$Override/Gizmo.show()
	
	firstpos = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	firstsize = Vector3(
		_get_object(idx).Size.x,
		_get_object(idx).Size.y,
		_get_object(idx).Size.z
	)
	
	resize_recent = ""
	
	selected = idx
	focus = true
	
	if get_node("%Inspector").active == true:
		get_node("%Inspector")._update(segment[selected], selected)
	
	Sound._play("Dot")
	
func _decal_selected(idx : int):
	
	if block_gizmo == true:
		return
	
	$Override/Gizmo.translation = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	$Override/Gizmo.show()
	
	$Override._remove_outline()
	
	resize_recent = ""
	
	selected = idx
	focus = true
	
	Sound._play("Dot")

func _powerup_selected(idx : int):
	
	if block_gizmo == true:
		return
	
	$Override/Gizmo.translation = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	$Override/Gizmo.show()
	
	$Override._remove_outline()
	
	resize_recent = ""
	
	selected = idx
	focus = true
	
	Sound._play("Dot")
	
func _score_selected(idx : int):
	
	if block_gizmo == true:
		return
	
	$Override/Gizmo.translation = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	$Override/Gizmo.show()
	
	$Override._remove_outline()
	
	resize_recent = ""
	
	selected = idx
	focus = true
	
	Sound._play("Dot")
	
func _obstacle_selected(idx : int):
	
	if block_gizmo == true:
		return
	
	$Override/Gizmo.translation = Vector3(
		_get_object(idx).Position.x,
		_get_object(idx).Position.y,
		_get_object(idx).Position.z
	)
	
	$Override/Gizmo.show()
	
	$Override._remove_outline()
	
	resize_recent = ""
	
	selected = idx
	focus = true
	
	Sound._play("Dot")

# オブジェクトが動かされた時の処理
func _object_move(position : Vector3):
	
	if focus == false:
		return
	
	if _get_object(selected).Name == "box": # ボックス
	
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Box.get_node("Box_" + str(selected)).translation = position
		
		get_node("%Override")._remove_outline()
		get_node("%Override")._make_outline(
			Vector3(
				position.x,
				position.y,
				position.z
			),
			Vector3(
				_get_object(selected).Size.x,
				_get_object(selected).Size.y,
				_get_object(selected).Size.z
			)
		)
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})

	if _get_object(selected).Name == "decal": # デカール
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Decal.get_node("Decal_" + str(selected)).translation = position
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})

	if _get_object(selected).Name == "powerup": # パワーアップ
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Powerup.get_node("Powerup_" + str(selected)).translation = position
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
		
	if _get_object(selected).Name.begins_with("score"): # クリスタル
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Score.get_node("Score_" + str(selected)).translation = position
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
		
	if _get_object(selected).Name == "bar": # バー（棒）
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Bar_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Bar_" + str(selected))._update(true)
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
		
	if _get_object(selected).Name == "sweeper": # スイーパー
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Sweeper_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Sweeper_" + str(selected))._update()
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
		
	if _get_object(selected).Name == "foldwindow": # 折り畳み
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Foldwindow_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Foldwindow_" + str(selected))._update()
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
		
	if _get_object(selected).Name == "beatwindow": # 折り畳み（ビート）
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Beatwindow_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Beatwindow_" + str(selected))._update()
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})

	if _get_object(selected).Name == "rotor": # プロペラ
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Rotor_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Rotor_" + str(selected))._update()
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})
	
	if _get_object(selected).Name == "revolver": # リボルバー
		
		$Override._remove_outline()
		
		var default_pos = _get_object(selected).Position
		
		if snap == true:
			
			var offset = Vector3(
				fmod(default_pos.x, 1.0),
				fmod(default_pos.y, 1.0),
				fmod(default_pos.z, 1.0)
			)
			
			position.x = int(position.x) + offset.x
			position.y = int(position.y) + offset.y
			position.z = int(position.z) + offset.z
			
			if !Vector3(default_pos.x, default_pos.y, default_pos.z) == position:
				Sound._play("Dot")
		
		$Object/Obstacle.get_node("Revolver_" + str(selected)).translation = position
		$Object/Obstacle.get_node("Revolver_" + str(selected))._update()
		
		_set_object(selected, "Position", {
			x = position.x,
			y = position.y,
			z = position.z
		})

# オブジェクトのサイズが変更された時の処理
func _object_size(axis : String, value : float):
	
	if focus == false:
		return
	
	if _get_object(selected).Name == "box": # ボックス
		
		if axis in ["x", "z"]:
			value *= -1
		
		var fixed = Vector3(
			_get_object(selected).Size.x,
			_get_object(selected).Size.y,
			_get_object(selected).Size.z
		)
		
		fixed[axis] += value
		
		if snap == true:
			
			if !resize_recent == axis:
				resize_snap = Vector3(
					_get_object(selected).Size.x,
					_get_object(selected).Size.y,
					_get_object(selected).Size.z
				)
				resize_recent = axis
			
			resize_snap[axis] += value
			
			var offset = Vector3(
				fmod(_get_object(selected).Size.x, 1.0),
				fmod(_get_object(selected).Size.y, 1.0),
				fmod(_get_object(selected).Size.z, 1.0)
			)
			
			fixed[axis] = int(resize_snap[axis]) + offset[axis]
			
			if !_get_object(selected).Size[axis] == fixed[axis]:
				Sound._play("Dot")
		
		if fixed[axis] < 0:
			fixed[axis] = 0.01
		
		$Object/Box.get_node("Box_" + str(selected)).scale = fixed
		$Object/Box.get_node("Box_" + str(selected))._update_uv()
		
		get_node("%Override")._remove_outline()
		get_node("%Override")._make_outline(
			Vector3(
				_get_object(selected).Position.x,
				_get_object(selected).Position.y,
				_get_object(selected).Position.z
			),
			Vector3(
				fixed.x,
				fixed.y,
				fixed.z
			)
		)
		
		_set_object(selected, "Size", {
			x = fixed.x,
			y = fixed.y,
			z = fixed.z
		})
		
	if _get_object(selected).Name == "decal": # デカール
		
		if axis in ["x", "z"]:
			value *= -1
		
		var fixed = Vector3(
			_get_object(selected).Size.x,
			_get_object(selected).Size.y,
			0
		)
		
		fixed[axis] += value
		
		if snap == true:
			
			if !resize_recent == axis:
				resize_snap = Vector3(
					_get_object(selected).Size.x,
					_get_object(selected).Size.y,
					0
				)
				resize_recent = axis
			
			resize_snap[axis] += value
			
			var offset = Vector3(
				fmod(_get_object(selected).Size.x, 1.0),
				fmod(_get_object(selected).Size.y, 1.0),
				fmod(0, 1.0)
			)
			
			fixed[axis] = int(resize_snap[axis]) + offset[axis]
			
			if !_get_object(selected).Size[axis] == fixed[axis]:
				Sound._play("Dot")
		
		if fixed[axis] < 0:
			fixed[axis] = 0.01
		
		$Object/Decal.get_node("Decal_" + str(selected))._scale(fixed)
		
		_set_object(selected, "Size", {
			x = fixed.x,
			y = fixed.y,
			z = 0
		})
	
	if _get_object(selected).Name in [
		"powerup", "score", "bar", "sweeper",
		"foldwindow", "beatwindow", "rotor", "revolver"
		]:
		
		var pos = Vector3(
			_get_object(selected).Position.x,
			_get_object(selected).Position.y,
			_get_object(selected).Position.z
		)
		
		$Override/Gizmo.translation = pos

# オブジェクトが離された時の処理
func _object_release():
	
	if focus == false:
		return
	
	get_node("%Override")._remove_general_outline()
	
	for i in range(segment.size()):
		if segment[i].Name == "box":
			
			var pos = Vector3(
				segment[i].Position.x,
				segment[i].Position.y,
				segment[i].Position.z
			)
			
			var size = Vector3(
				segment[i].Size.x,
				segment[i].Size.y,
				segment[i].Size.z
			)
			
			get_node("%Override")._make_general_outline(pos, size)
	
	get_tree().call_group("GeneralOutline","_visible",$UI.general_outline)
	
	if segment[selected].has("Position"):
		get_node("%Gizmo").translation = Vector3(
			segment[selected].Position.x,
			segment[selected].Position.y,
			segment[selected].Position.z
		)

# スナップ
func _snap(active : bool):
	snap = active

# 衝突チェック
func _check(active : bool):
	get_tree().call_group("Obstacle", "_check", active)
	
# プレビュー
func _preview(active : bool):
	
	preview = active
	
	$UI.preview = active
	$Override/Gizmo.hide()
	
	_block(active)
	
	get_node("%Camera").block = true
	
	if active == true:
		$Camera/CameraTween.interpolate_property(
			$Camera,
			"translation",
			$Camera.translation,
			Vector3(
				0,
				1,
				$Camera.translation.z
			),
			0.2,
			Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		
		$Camera/CameraTween.start()
		
		$Camera/CameraTween.interpolate_property(
			$Camera,
			"rotation_degrees",
			$Camera.rotation_degrees,
			Vector3(
				0,
				0,
				0
			),
			0.2,
			Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		
		$Camera/CameraTween.start()
		
		$Camera/CameraTween.interpolate_property(
			$Camera,
			"fov",
			80,
			60,
			0.2,
			Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		
		$Camera/CameraTween.start()
		
		$UI.hide()
		$Inspector.hide()
		$Preview.show()
	
	else:
		
		$Camera/CameraTween.interpolate_property(
			$Camera,
			"fov",
			60,
			80,
			0.2,
			Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		
		$Camera/CameraTween.start()
		
		$Camera.block = false
		_block(false)
		
		$UI.show()
		$Inspector.show()
		$Preview.hide()

# クイックテスト用の処理
func _quicktest():
	var template = []
	
	for i in range(segment.size()):
		if segment[i].has("Template"):
			template.append(segment[i].Template)
	
	OS.set_clipboard(
		segmentcompressor._compress(
			segmentgenerator._generate_segment(segment, segment_info),
			template
		)
	)
	
	GlobalPopup._pop("Quicktest")
	
	
# オブジェクト追加時のロック
func _block(active : bool):
	block_gizmo = active
	
	if active == true:
		if focus == true:
			focus = false
		
		$Override._remove_outline()

# スケーリング
func _scale(active : bool):
	scaling = active
	
	if scaling == false:
		$Override/Gizmo._mode("move")
	else:
		$Override/Gizmo._mode("scaling")

# UIからのインスペクター表示のリクエスト
func _inspector():
	if focus == true:
		$Inspector/Inspector._show(segment[selected], selected)
	else:
		Notice._show("inspector_error")

# ポップアップからのリクエスト
func _popup(window : String, action : String, arg):
	
	if window == "OpenFile":
		if action == "Open":
			
			# セグメントのロード
			segmentloader._load_segment(HyperFile._get_path("segment/" + arg))
			segment = segmentloader._get_segment()
			
			$UI/Sidemenu/Panel/FileName/Filaname.text = arg
			
			_make_segment()
			
			Notice._show("opened")
			
			$UI._close_side()
			
	if window == "NewWarning":
		if action == "New":
			
			segment = []
			_reset_segment()
			
			$UI/Sidemenu/Panel/FileName/Filaname.text = "Unsaved"
			
			$UI._close_side()
			
	if window == "SaveFile":
		if action == "Save":
			
			# セグメントの生成
			
			var generated = segmentgenerator._generate_segment(segment, segment_info)
			
			# セグメントの保存
			
			file.open(HyperFile._get_path("segment/" + arg), File.WRITE)
			file.store_string(generated)
			file.close()

			Notice._show("exported")
			
			$UI._close_side()
	
	if window == "Quicktest":
		if action == "Complete":
			
			OS.shell_open("hyperspaceexporter://launch")
