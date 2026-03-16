extends CanvasLayer

onready var root = get_parent()

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("Debug"):
		
		if self.visible == false:
			self.show()
		else:
			self.hide()
		
		Sound._play("Select")

func _on_River_button_down():
	root.segmentloader._load_segment(HyperFile._get_path("segment/river_3.xml.mp3"))
	root.segment = root.segmentloader._get_segment()
	root._make_segment()
	self.hide()

func _on_Brownie_button_down():
	root.segmentloader._load_segment(HyperFile._get_path("segment/brownie_2.xml.mp3"))
	root.segment = root.segmentloader._get_segment()
	root._make_segment()
	self.hide()

func _on_MainMenu_button_down():
	SceneAnimate._change_scene("res://Title.tscn")
