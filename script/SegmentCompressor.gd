extends Node

# セグメントエクスポーターに共有するための圧縮ツール

class_name SegmentCompressor

func _compress(segment : String, template : Array):
	
	# ルール
	var rule = [
		["<box", "∞b"],
		["<segment", "∞s"],
		["<obstacle", "∞o"],
		["<decal", "∞d"],
		["<powerup", "∞p"],
		["</segment>", "∞f"],
		["pos=", "&p"],
		["size=", "&s"],
		["tile=", "&tl"],
		["hidden=", "&h"],
		["color=", "&c"],
		["template=", "&tmp"],
		["type=", "&tp"],
		["reflection=", "&r"],
		["param1=", "^1"],
		["param2=", "^2"],
		["param3=", "^3"],
		["param4=", "^4"],
		["param5=", "^5"],
		["param6=", "^6"],
		["param7=", "^7"],
		["param8=", "^8"],
		["param9=", "^9"],
		["param10=", "^10"],
		["param11=", "^11"],
		["/>", "$"],
		["0.", "#"],
		[".5", "Δ"],
		["\n", ""],
		["\t", ""],
		["rot=\"0 0 0\"", ""]
	]
	
	var template_id = ""
	var segment_data = ""
	var compressed_template = {}
	
	# テンプレートのID付け
	
	var id = 0
	
	for i in range(template.size()):
		if !template[i] in compressed_template.keys():
			template_id += "@" + str(id) + template[i]
			compressed_template[template[i]] = "@" + str(id)
			id += 1
	
	# テンプレートIDエリアの分離
	template_id += "|"
	
	# 置き換え
	
	segment_data = segment
	
	for i in range(rule.size()):
		segment_data = segment_data.replace(rule[i][0], rule[i][1])
	
	# IDに置き換え
	
	var key = compressed_template.keys()
	
	for i in range(compressed_template.size()):
		segment_data = segment_data.replace("&tmp\"" + key[i] + "\"", "&tmp\"" + compressed_template[key[i]] + "\"")
	
	# 結合
	
	var result = template_id + segment_data
	
	return result
