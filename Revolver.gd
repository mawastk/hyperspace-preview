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
	
	$Width.text = ""
	$Height.text = ""
	
	$Speed.text = ""
	$Offset.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	
	$RotationX.release_focus()
	$RotationY.release_focus()
	$RotationZ.release_focus()
	
	$Width.release_focus()
	$Height.release_focus()
	
	$Speed.release_focus()
	$Offset.release_focus()

func _ready():
	
	$PositionX.connect("text_changed", self, "_positionX")
	$PositionY.connect("text_changed", self, "_positionY")
	$PositionZ.connect("text_changed", self, "_positionZ")
	$RotationX.connect("text_changed", self, "_rotationX")
	$RotationY.connect("text_changed", self, "_rotationY")
	$RotationZ.connect("text_changed", self, "_rotationZ")
	
	$Width.connect("text_changed", self, "_width")
	$Height.connect("text_changed", self, "_height")
	
	$Speed.connect("text_changed", self, "_speed")
	$Offset.connect("text_changed", self, "_offset")
	
	$Template.connect("button_down", self, "_template_down")
	$Template.connect("button_up", self, "_template_up")

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

func _width(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Width", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _height(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Height", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _speed(new_text):
	var value = float(new_text)
	root._set_object(inspector.selected_id, "Speed", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")
	
func _offset(new_text):
	var value = float(new_text)
	root._set_object(inspector.selected_id, "Offset", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _template_down():
	Sound._play("Select")

func _template_up():
	GlobalPopup._pop("GlassTemplate", [$TemplateName.text, "RevolverInspector"])
