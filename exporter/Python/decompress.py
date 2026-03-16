import os


rule = [
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
	[".5", "Δ"]
]


def _break_template(template : str):

	# テンプレートID解析
	
	template_split = []
	template_process = template.replace("@0", "")
	template_list = {}
	
	for i in range(template.count("@")):
		template_process = template_process.replace("@" + str(i), "!hyper")
	
	template_split = template_process.split("!hyper")
	
	for i in range(len(template_split)):
		template_list[template_split[i]] = "@" + str(i)
	
	return template_list



def _segment_decompress(segment : str):
	
	# 置き換え
	
	segment_data = segment
	
	for i in range(len(rule)):
		segment_data = segment_data.replace(rule[i][1], rule[i][0])
	
	return segment_data
	
	
	
def _patch_template(segment : str, template : dict):
	
	# テンプレートリストから置き換え
	
	segment_data = segment
	
	for i in range(len(template)):
		segment_data = segment_data.replace(template[list(template)[i]], list(template)[i])
	
	return segment_data
	
	
	
def _decompress(text : str):
	
	# テンプレートリスト
	template_data = {}
	
	template_area = text[0:text.find("|")]
	
	template_list = _break_template(template_area)
	
	# セグメント
	segment_area = text[text.find("|") + 1:]
	
	segment_data = _segment_decompress(segment_area)
	
	result = _patch_template(segment_data, template_list)
	
	return result
