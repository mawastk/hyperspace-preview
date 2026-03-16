extends Node

# オブジェクト
var box = preload("res://object/Box.tscn")
var decal = preload("res://object/Decal.tscn")
var powerup = preload("res://object/Powerup.tscn")
var score = preload("res://object/Score.tscn")
var bar = preload("res://object/Bar.tscn")
var sweeper = preload("res://object/Sweeper.tscn")
var foldwindow = preload("res://object/Foldwindow.tscn")
var beatwindow = preload("res://object/Beatwindow.tscn")
var rotor = preload("res://object/Rotor.tscn")
var revolver = preload("res://object/Revolver.tscn")

func _make_object(segment, id = 0):
	
	if segment.Name == "box": # ボックス
		var box_instance = box.instance()
		
		box_instance.position = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		box_instance.size = Vector3(
			segment.Size.x,
			segment.Size.y,
			segment.Size.z
		)
		
		# テクスチャ
		
		var texture = TemplateManager._get_template("tile", segment.Template).texture
		
		# テンプレート外に書かれた情報を優先
		
		if segment.has("Tile"):
			texture = [segment.Tile]
		
		if texture.size() == 3:
			
			box_instance._set_texture(texture[0], texture[1], texture[2])
		
		else:
			
			box_instance._set_texture(texture[0])
		
		# テクスチャの色
		
		var color = TemplateManager._get_tile_color(segment.Template)
		
		# テンプレート外に書かれた情報を優先
		
		if segment.has("Color"):
			color = [
				Color(segment.Color.r, segment.Color.g, segment.Color.b)
			]
		
		if color.size() == 3:
			
			box_instance._set_color(color[0], color[1], color[2])
		
		else:
			
			box_instance._set_color(color[0])
		
		# タイルサイズ
		
		var tilesize = TemplateManager._get_template("tile", segment.Template)
		
		# テンプレート外に書かれた情報を優先
		
		if tilesize.has("size"):
			
			if segment.has("TileSize"):
				tilesize.size = [
					segment.TileSize.x,
					segment.TileSize.y,
					segment.TileSize.z
				]
			
			if tilesize.size.size() == 1:
				
				box_instance._set_tilesize(
					tilesize.size[0],
					tilesize.size[0],
					tilesize.size[0]
				)
			
			else:
				
				box_instance._set_tilesize(
					tilesize.size[0],
					tilesize.size[1],
					tilesize.size[2]
				)
		
		box_instance.name = "Box_" + str(id)
		
		box_instance.id = id
		
		return box_instance
		
	if segment.Name == "powerup": # パワーアップ
		var powerup_instance = powerup.instance()
		
		powerup_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		powerup_instance.type = segment.Type
		
		powerup_instance.name = "Powerup_" + str(id)
		powerup_instance.id = id
		
		return powerup_instance
		
	if segment.Name == "decal": # デカール
		
		var decal_instance = decal.instance()
		
		decal_instance.position = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		if segment.has("Size"):
		
			decal_instance.size = Vector3(
				segment.Size.x,
				segment.Size.y,
				0
			)
		
		if segment.has("Color"): # デカールはColorパラメーターを持たない可能性がある
		
			decal_instance.color.r = segment.Color.r
			decal_instance.color.g = segment.Color.g
			decal_instance.color.b = segment.Color.b
			
		if segment.has("Rotation"):
		
			decal_instance.rot.x = segment.Rotation.x
			decal_instance.rot.y = segment.Rotation.y
			decal_instance.rot.z = segment.Rotation.z
		
		# デカールの画像ファイルのナンバリングに合わせる
		
		var number = segment.Tile
		var fixed_number = ""
		
		if number > -1: # ドアのデカールの場合（数値がマイナスの場合）は別の処理
		
			if str(number).length() == 1:
				fixed_number = "00" + str(number)
			if str(number).length() == 2:
				fixed_number = "0" + str(number)
			if str(number).length() == 3:
				fixed_number = str(number)
			
			decal_instance.type = "normal"
			
			decal_instance.texture = load("res://image/decal/decal" + fixed_number + ".png")
		
		else:
			
			fixed_number = str(abs(number))
			
			decal_instance.type = "door"
			
			decal_instance.texture = load("res://image/door/door" + fixed_number + ".png")
		
		decal_instance.name = "Decal_" + str(id)
		decal_instance.id = id
		
		return decal_instance

	if segment.Name.begins_with("score"): # クリスタル
		
		var score_instance = score.instance()
		
		score_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		score_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		score_instance._type(segment.Name)
		score_instance._template(segment.Template)
		
		score_instance.name = "Score_" + str(id)
		score_instance.id = id
		
		return score_instance
		
	if segment.Name == "bar": # バー（棒）
		
		var bar_instance = bar.instance()
		
		bar_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		bar_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		bar_instance.template = segment.Template
		
		bar_instance.thickness = segment.Thickness
		bar_instance.height = segment.Height
		bar_instance.maxwidth = segment.Maxwidth
		
		bar_instance.move = segment.Move
		bar_instance.speed = segment.Speed
		bar_instance.offset = segment.Offset
		
		bar_instance.blocker = segment.Blocker
		
		bar_instance._update()
		
		bar_instance.name = "Bar_" + str(id)
		bar_instance.id = id
		
		return bar_instance
		
	if segment.Name == "sweeper": # スイーパー
		
		var sweeper_instance = sweeper.instance()
		
		sweeper_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		sweeper_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		sweeper_instance.template = segment.Template
		
		sweeper_instance.width = segment.Width
		sweeper_instance.height = segment.Height
		sweeper_instance.panewidth = segment.Panewidth
		sweeper_instance.thickness = segment.Thickness
		
		sweeper_instance.speed = segment.Speed
		sweeper_instance.offset = segment.Offset
		sweeper_instance.offset_random = segment.OffsetRandom
		
		sweeper_instance.beat = segment.Beat
		
		sweeper_instance.strength = segment.Strength
		sweeper_instance.blocker = segment.Blocker
		
		sweeper_instance._update()
		
		sweeper_instance.name = "Sweeper_" + str(id)
		sweeper_instance.id = id
		
		return sweeper_instance
		
	if segment.Name == "foldwindow": # 折り畳み
		
		var foldwindow_instance = foldwindow.instance()
		
		foldwindow_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		foldwindow_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		foldwindow_instance.template = segment.Template
		
		foldwindow_instance.width = segment.Width
		foldwindow_instance.height = segment.Height
		foldwindow_instance.distance = segment.Distance
		foldwindow_instance.angle = segment.Angle
		
		foldwindow_instance._update()
		
		foldwindow_instance.name = "Foldwindow_" + str(id)
		foldwindow_instance.id = id
		
		return foldwindow_instance
		
	if segment.Name == "beatwindow": # 折り畳み（ビート）
		
		var beatwindow_instance = beatwindow.instance()
		
		beatwindow_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		beatwindow_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		beatwindow_instance.template = segment.Template
		
		beatwindow_instance.width = segment.Width
		beatwindow_instance.beat = segment.Beat
		beatwindow_instance.offset = segment.Offset
		
		beatwindow_instance._update()
		
		beatwindow_instance.name = "Beatwindow_" + str(id)
		beatwindow_instance.id = id
		
		return beatwindow_instance
	
	if segment.Name == "rotor": # プロペラ
		
		var rotor_instance = rotor.instance()
		
		rotor_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		rotor_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		rotor_instance.template = segment.Template
		
		rotor_instance.length = segment.Length
		rotor_instance.width = segment.Width
		rotor_instance.thickness = segment.Thickness
		
		rotor_instance.arms = segment.Arms
		rotor_instance.radius = segment.Radius
		
		rotor_instance.speed = segment.Speed
		rotor_instance.beat = segment.Beat
		rotor_instance.offset = segment.Offset
		rotor_instance.offset_random = segment.OffsetRandom
		
		rotor_instance._update()
		
		rotor_instance.name = "Rotor_" + str(id)
		rotor_instance.id = id
		
		return rotor_instance
	
	if segment.Name == "revolver": # リボルバー
		
		var revolver_instance = revolver.instance()
		
		revolver_instance.translation = Vector3(
			segment.Position.x,
			segment.Position.y,
			segment.Position.z
		)
		
		revolver_instance.rotation = Vector3(
			segment.Rotation.x,
			segment.Rotation.y,
			segment.Rotation.z
		)
		
		revolver_instance.template = segment.Template
		
		revolver_instance.height = segment.Height
		revolver_instance.width = segment.Width
		revolver_instance.speed = segment.Speed
		revolver_instance.offset = segment.Offset
		
		revolver_instance._update()
		
		revolver_instance.name = "Revolver_" + str(id)
		revolver_instance.id = id
		
		return revolver_instance
