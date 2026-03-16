extends Node

var file = File.new()

# リアルタイムテンプレート
var template = {
	tile = {},
	crystal = {},
	glass = {}
}

# テンプレート読み込み
func _load_template():
	
	file.open("res://data/TileTemplate.json",File.READ)
	
	template.tile = parse_json(file.get_as_text())
	
	file.close()
	
	file.open("res://data/CrystalTemplate.json",File.READ)
	
	template.crystal = parse_json(file.get_as_text())
	
	file.close()
	
	file.open("res://data/GlassTemplate.json",File.READ)
	
	template.glass = parse_json(file.get_as_text())
	
	file.close()

# テンプレート取得
func _get_template(type : String, template_name : String):
	
	match type:
		"tile":
			if template.tile.has(template_name):
				return template.tile[template_name]
			else:
				return template.tile["none"]
		"crystal":
			if template.crystal.has(template_name):
				return template.crystal[template_name]
			else:
				return template.crystal["none"]
		"glass":
			if template.glass.has(template_name):
				return template.glass[template_name]
			else:
				return template.glass["none"]

# テンプレートのリストを取得
func _get_template_list(type : String):
	
	match type:
		"tile":
			return template.tile
		"crystal":
			return template.crystal
		"glass":
			return template.glass

# タイルテクスチャ読み込み
func _get_tile_texture(number : int):
	
	var fixed_number = ""
	
	if str(number).length() == 1:
		fixed_number = "00" + str(number)
	if str(number).length() == 2:
		fixed_number = "0" + str(number)
	if str(number).length() == 3:
		fixed_number = str(number)
		
	return load("res://image/tile/tile" + fixed_number + ".png")

# タイルテクスチャの色を読み込み
func _get_tile_color(template_name : String):
	if template.tile.has(template_name):
		
		if template.tile[template_name].modulate.size() == 3:
			
			return [Color(
						template.tile[template_name].modulate[0],
						template.tile[template_name].modulate[1],
						template.tile[template_name].modulate[2]
					)]
		
		else:
		
			return [Color(
						template.tile[template_name].modulate[0],
						template.tile[template_name].modulate[1],
						template.tile[template_name].modulate[2]
					),
					Color(
						template.tile[template_name].modulate[3],
						template.tile[template_name].modulate[4],
						template.tile[template_name].modulate[5]
					),
					Color(
						template.tile[template_name].modulate[6],
						template.tile[template_name].modulate[7],
						template.tile[template_name].modulate[8]
					)]
		
	else:
		return [Color(1.0, 1.0, 1.0)]
