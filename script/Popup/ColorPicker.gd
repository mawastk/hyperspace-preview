extends Node2D

var color = Color(1.0, 1.0, 1.0)

var recent_color = Color(1.0, 1.0, 1.0)

var pallet = [
	null, null, null, null,
	null, null, null
]

var sender

func _reset():
	
	var arg = get_node("../../../").argument
	sender = arg[1]
	
	$Slider/R.value = arg[0].r8
	$Slider/G.value = arg[0].g8
	$Slider/B.value = arg[0].b8

func _regist(id : int, color_arg : Color):
	pallet[id] = color_arg
	id += 1
	get_node("Pallet/Preview/" + str(id)).color.a = 1.0
	get_node("Pallet/Preview/" + str(id)).color = color_arg

func _load(id : int):
	
	Sound._play("Laser")
	
	$Slider/R.value = pallet[id].r8
	$Slider/G.value = pallet[id].g8
	$Slider/B.value = pallet[id].b8
	
	color.r = float($Slider/R.value) / 255.0
	color.g = float($Slider/G.value) / 255.0
	color.b = float($Slider/B.value) / 255.0
	
	$Preview/Preview.color = color
	$Preview/DecalPreview.modulate = color
	$Preview/TilePreview.modulate = color
	
	$Preview/ColorText.text = "Smash hit ("
	$Preview/ColorText.text += str(color.r).substr(0,4) + " " + str(color.g).substr(0,4) + " " + str(color.b).substr(0,4)
	$Preview/ColorText.text += ")\n\nrgb ("  + str(color.r8) + " " + str(color.g8) + " " + str(color.b8) + ")"

	$LineR.text = str(color.r)
	$LineG.text = str(color.g)
	$LineB.text = str(color.b)

func _physics_process(_delta):
	
	color.r = float($Slider/R.value) / 255.0
	color.g = float($Slider/G.value) / 255.0
	color.b = float($Slider/B.value) / 255.0
	
	$Preview/Preview.color = color
	$Preview/DecalPreview.modulate = color
	$Preview/TilePreview.modulate = color
	
	$Preview/ColorText.text = "Smash hit ("
	$Preview/ColorText.text += str(color.r).substr(0,4) + " " + str(color.g).substr(0,4) + " " + str(color.b).substr(0,4)
	$Preview/ColorText.text += ")\n\nrgb ("  + str(color.r8) + " " + str(color.g8) + " " + str(color.b8) + ")"
	
	if !color == recent_color:
	
		$LineR.text = str(color.r)
		$LineG.text = str(color.g)
		$LineB.text = str(color.b)
		
		recent_color = color
	
func _on_LineR_text_changed(new_text):
	var fixed = Syntax._check_rawcolor(float(new_text))
	$Slider/R.value = fixed * 255
	Sound._play("Dot")

func _on_LineG_text_changed(new_text):
	var fixed = Syntax._check_rawcolor(float(new_text))
	$Slider/G.value = fixed * 255
	Sound._play("Dot")

func _on_LineB_text_changed(new_text):
	var fixed = Syntax._check_rawcolor(float(new_text))
	$Slider/B.value = fixed * 255
	Sound._play("Dot")

func _on_Pallet1_button_down():
	if pallet[0] == null:
		Sound._play("Powerup")
		_regist(0, color)
	_load(0)

func _on_Pallet2_button_down():
	if pallet[1] == null:
		Sound._play("Powerup")
		_regist(1, color)
	_load(1)

func _on_Pallet3_button_down():
	if pallet[2] == null:
		Sound._play("Powerup")
		_regist(2, color)
	_load(2)

func _on_Pallet4_button_down():
	if pallet[3] == null:
		Sound._play("Powerup")
		_regist(3, color)
	_load(3)

func _on_Pallet5_button_down():
	if pallet[4] == null:
		Sound._play("Powerup")
		_regist(4, color)
	_load(4)

func _on_Pallet6_button_down():
	if pallet[5] == null:
		Sound._play("Powerup")
		_regist(5, color)
	_load(5)

func _on_Pallet7_button_down():
	if pallet[6] == null:
		Sound._play("Powerup")
		_regist(6, color)
	_load(6)

func _on_Clear_button_down():
	Sound._play("Select")

func _on_Clear_button_up():
	pallet = [
		null, null, null, null,
		null, null, null
	]
	
	for i in range($Pallet/Preview.get_child_count()):
		$Pallet/Preview.get_child(i).color = Color(0.0, 0.0, 0.0, 0.0)
	Sound._play("Single")

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Select_button_down():
	Sound._play("Select")

func _on_Select_button_up():
	get_node("../../../")._send(self.name, "Select", [color, sender])
