extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	
	$TemplateName.text = ""
	
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	
	$RotationX.text = ""
	$RotationY.text = ""
	$RotationZ.text = ""
	
	$Panewidth.text = ""
	$Height.text = ""
	$Thickness.text = ""
	
	$Width.text = ""
	$Speed.text = ""
	$Offset.text = ""
	
	$TemplateName.release_focus()
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	
	$RotationX.release_focus()
	$RotationY.release_focus()
	$RotationZ.release_focus()
	
	$Panewidth.release_focus()
	$Height.release_focus()
	$Thickness.release_focus()
	
	$Width.release_focus()
	$Speed.release_focus()
	$Offset.release_focus()
	
	$Beat.pressed = false
	$RandomOffset.pressed = false

func _ready():
	
	$PositionX.connect("text_changed", self, "_positionX")
	$PositionY.connect("text_changed", self, "_positionY")
	$PositionZ.connect("text_changed", self, "_positionZ")
	$RotationX.connect("text_changed", self, "_rotationX")
	$RotationY.connect("text_changed", self, "_rotationY")
	$RotationZ.connect("text_changed", self, "_rotationZ")
	
	$Panewidth.connect("text_changed", self, "_panewidth")
	$Height.connect("text_changed", self, "_height")
	$Thickness.connect("text_changed", self, "_thickness")
	
	$Width.connect("text_changed", self, "_width")
	$Speed.connect("text_changed", self, "_speed")
	$Offset.connect("text_changed", self, "_offset")
	
	$Beat.connect("toggle", self, "_beat")
	$RandomOffset.connect("toggle", self, "_randomoffset")

func _positionX(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.x = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _positionY(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.y = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _positionZ(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.z = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _rotationX(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.x = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _rotationY(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.y = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _rotationZ(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.z = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _panewidth(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Panewidth", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _height(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Height", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _thickness(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Thickness", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _width(new_text):
	var value = int(Syntax._check_nominus_allowedzero(float(new_text)))
	root._set_object(inspector.selected_id, "Width", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _speed(new_text):
	var value = float(new_text)
	root._set_object(inspector.selected_id, "Speed", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _offset(new_text):
	var value = Syntax._check_nominus_allowedzero(float(new_text))
	root._set_object(inspector.selected_id, "Offset", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _beat(pressed):
	root._set_object(inspector.selected_id, "Beat", pressed, false)
	root._sync_object(inspector.selected_id)
	
func _randomoffset(pressed):
	root._set_object(inspector.selected_id, "OffsetRandom", pressed, false)
	root._sync_object(inspector.selected_id)

func _on_Template_button_down():
	Sound._play("Select")

func _on_Template_button_up():
	GlobalPopup._pop("GlassTemplate", [$TemplateName.text, "SweeperInspector"])
