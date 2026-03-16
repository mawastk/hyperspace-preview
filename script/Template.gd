extends Node2D

var text = [
	"Original template\nfrom smash hit",
	"System Template\nfrom Hyperspace",
	"Unknown template\nfrom segment"
]

var selected = ""
var sender = ""

func _reset():
	
	TemplateManager._load_template()
	
	$InfoCover.show()
	
	var template = TemplateManager._get_template_list("tile")
	var template_key = template.keys()
	
	$FileList.clear()
	
	for i in range(template_key.size()):
		
		var texture : StreamTexture = TemplateManager._get_tile_texture(template[template_key[i]].texture[0])
		var color = Color(template[template_key[i]].modulate[0], template[template_key[i]].modulate[1], template[template_key[i]].modulate[2])
		
		$FileList.add_item(" " + template_key[i], texture)
		$FileList.set_item_icon_modulate(i, color)
	
	var arg = get_node("../../../").argument
	sender = arg[1]
	
	_select(arg[0])
	
func _select(template_name : String):
	
	selected = template_name
	
	if !template_name in TemplateManager._get_template_list("tile").keys():
		
		$Preview/TemplateName.text = template_name
		$Preview/PreviewX.texture = TemplateManager._get_tile_texture(0)
		$Preview/PreviewY.texture = $Preview/PreviewX.texture
		$Preview/PreviewZ.texture = $Preview/PreviewX.texture
		$Preview/PreviewX.modulate = Color(1.0, 1.0, 1.0)
		$Preview/PreviewY.modulate = $Preview/PreviewX.modulate
		$Preview/PreviewZ.modulate = $Preview/PreviewX.modulate
		$Preview/TemplateOrigin.text = text[2]
		$Info/InfoText.text = "Warning: This template is\nnot registered."
		
		$InfoCover.hide()
		
		return
	
	var template = TemplateManager._get_template("tile", template_name)
	
	if template.texture.size() == 1:
		
		$Preview/PreviewX.texture = TemplateManager._get_tile_texture(template.texture[0])
		$Preview/PreviewY.texture = $Preview/PreviewX.texture
		$Preview/PreviewZ.texture = $Preview/PreviewX.texture
	
	else:
		
		$Preview/PreviewX.texture = TemplateManager._get_tile_texture(template.texture[0])
		$Preview/PreviewY.texture = TemplateManager._get_tile_texture(template.texture[1])
		$Preview/PreviewZ.texture = TemplateManager._get_tile_texture(template.texture[2])
		
	if template.modulate.size() == 3:
		
		$Preview/PreviewX.modulate = Color(
			template.modulate[0], template.modulate[1], template.modulate[2]
		)
		$Preview/PreviewY.modulate = $Preview/PreviewX.modulate
		$Preview/PreviewZ.modulate = $Preview/PreviewX.modulate
	
	else:
		
		$Preview/PreviewX.modulate = Color(
			template.modulate[0], template.modulate[1], template.modulate[2]
		)
		$Preview/PreviewY.modulate = Color(
			template.modulate[3], template.modulate[4], template.modulate[5]
		)
		$Preview/PreviewZ.modulate = Color(
			template.modulate[6], template.modulate[7], template.modulate[8]
		)
		
	if template.has("system"):
		$Preview/TemplateOrigin.text = text[1]
	else:
		$Preview/TemplateOrigin.text = text[0]
		
	var info = ""
	
	info += "Tile: "
	
	if template.has("tile"):
		info += str(template.tile)
	else:
		info += "0"
	
	info += "\nColor: "
	
	if template.has("modulate"):
		for i in range(template.modulate.size()):
			if i % 3 == 0:
				info += "\n"
			info += str(float(template.modulate[i])) + " "
	else:
		info += "1.0 1.0 1.0"
	
	info += "\nReflection: "
	
	if template.has("reflection"):
		info += str(template.reflection)
	else:
		info += "false"
	
	info += "\ntilesize: "
	
	if template.has("size"):
		for i in range(template.size.size()):
			info += str(template.size[i]) + " "
	else:
		info += "auto"
		
	info += "\ntilerot: "
	
	if template.has("rotation"):
		for i in range(template.rotation.size()):
			info += str(template.rotation[i]) + " "
	else:
		info += "auto"
	
	$Info/InfoText.text = info
	
	$Preview/TemplateName.text = template_name
	
	$InfoCover.hide()
	
func _on_FileList_item_selected(index):
	
	var template = $FileList.get_item_text(index).substr(1, -1)
	
	Sound._play("Dot")
	
	_select(template)

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Select_button_down():
	Sound._play("Select")

func _on_Select_button_up():
	get_node("../../../")._send(self.name, "Select", [selected, sender])
