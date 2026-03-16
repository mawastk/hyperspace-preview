extends Node2D

var text = [
	"Original template\nfrom smash hit",
	"System Template\nfrom Hyperspace",
	"Unknown template\nfrom segment"
]

var selected = ""
var sender = ""

var list_texture = preload("res://image/popup/glasspreview.png")

func _reset():
	
	TemplateManager._load_template()
	
	$InfoCover.show()
	
	var template = TemplateManager._get_template_list("glass")
	var template_key = template.keys()
	
	$FileList.clear()
	
	for i in range(template_key.size()):
		
		var texture : StreamTexture = list_texture
		var color = Color(template[template_key[i]].color[0], template[template_key[i]].color[1], template[template_key[i]].color[2])
		
		$FileList.add_item(" " + template_key[i], texture)
		$FileList.set_item_icon_modulate(i, color)
	
	var arg = get_node("../../../").argument
	sender = arg[1]
	
	_select(arg[0])
	
func _select(template_name : String):
	
	selected = template_name
	
	if !template_name in TemplateManager._get_template_list("glass").keys():
		
		$Preview/TemplateName.text = template_name
		$Preview/Preview.modulate = Color(1.0, 1.0, 1.0)
		$Preview/TemplateOrigin.text = text[2]
		$Info/InfoText.text = "Warning: This template is\nnot registered."
		
		$InfoCover.hide()
		
		return
		
	var template = TemplateManager._get_template_list("glass")[selected]
	
	$Preview/Preview.modulate = Color(
		template.color[0],
		template.color[1],
		template.color[2]
	)
	
	if template.has("system"):
		$Preview/TemplateOrigin.text = text[1]
	else:
		$Preview/TemplateOrigin.text = text[0]
	
	var info = "Color: "
	
	info += str(template.color[0]) + ", " + str(template.color[1]) + ", " + str(template.color[2])
	
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
