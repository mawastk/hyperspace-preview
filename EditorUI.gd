extends CanvasLayer

onready var root = get_parent()

var sidemenu = false

var guide = false
var general_outline = false
var snap = false
var scaling = false
var check = false
var preview = false

func _close_side():
	$SidemenuAnimation.stop()
	$SidemenuAnimation.play("Hide")
	Sound._play("Close")
	get_node("%Camera").block = false
	$Sidemenu/NoneArea.hide()
	sidemenu = false

func _on_Menu_button_down():
	Sound._play("Select")
	$MenuImage.modulate = Color("42ffffff")
	get_node("%Camera").block = true
	if get_node("%Inspector").active == true:
		get_node("%Inspector")._close()

func _on_Menu_button_up():
	$SidemenuAnimation.stop()
	$SidemenuAnimation.play("Show")
	Sound._play("Show")
	$MenuImage.modulate = Color("a9ffffff")
	get_node("%Camera").block = true
	$Sidemenu/NoneArea.show()
	sidemenu = true

func _on_NoneArea_button_down():
	if sidemenu == true:
		$SidemenuAnimation.stop()
		$SidemenuAnimation.play("Hide")
		Sound._play("Close")
		get_node("%Camera").block = false
		$Sidemenu/NoneArea.hide()
		sidemenu = false

func _on_Up_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").up = true

func _on_Up_released():
	get_node("../").get_node("Camera").up = false

func _on_Down_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").down = true

func _on_Left_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").left = true

func _on_Left_released():
	get_node("../").get_node("Camera").left = false

func _on_Right_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").right = true
	
func _on_Right_released():
	get_node("../").get_node("Camera").right = false

func _on_Space_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").space = true

func _on_Space_released():
	get_node("../").get_node("Camera").space = false

func _on_Fall_pressed():
	get_node("../").mobile = true
	get_node("../").get_node("Camera").fall = true

func _on_Fall_released():
	get_node("../").get_node("Camera").fall = false

func _on_Down_released():
	get_node("../").get_node("Camera").down = false

func _on_OpenSegment_button_down():
	Sound._play("Select")

func _on_OpenSegment_button_up():
	GlobalPopup._pop("OpenFile")

func _on_New_button_down():
	Sound._play("Select")

func _on_New_button_up():
	GlobalPopup._pop("NewWarning")

func _on_CameraReset_button_down():
	Sound._play("Select")
	$CameraResetImage.modulate = Color("42ffffff")

func _on_CameraReset_button_up():
	Sound._play("Transition")
	$CameraResetImage.modulate = Color("a9ffffff")
	get_node("%Camera")._reset()

func _on_Guide_button_down():
	Sound._play("Select")
	$GuideImage.modulate = Color("42ffffff")

func _on_Guide_button_up():
	if guide == false:
		get_node("../").get_node("Override/Guide").show()
		get_node("../").get_node("Override/Grid").show()
		get_node("../")._update_autosize()
		$GuideImage.modulate = Color("a9ffffff")
		guide = true
	else:
		get_node("../").get_node("Override/Guide").hide()
		get_node("../").get_node("Override/Grid").hide()
		$GuideImage.modulate = Color("42ffffff")
		guide = false

func _on_SaveSegment_button_down():
	Sound._play("Select")

func _on_SaveSegment_button_up():
	GlobalPopup._pop("SaveFile")

func _on_SegmentOption_button_down():
	Sound._play("Select")

func _on_SegmentOption_button_up():
	GlobalPopup._pop("SegmentOption", get_parent().segment_info)

func _on_About_button_down():
	Sound._play("Select")

func _on_About_button_up():
	GlobalPopup._pop("About")

func _on_Grid_button_down():
	Sound._play("Select")
	$GridImage.modulate = Color("42ffffff")

func _on_Grid_button_up():
	if general_outline == false:
		general_outline = true
		$GridImage.modulate = Color("a9ffffff")
	else:
		general_outline = false
		$GridImage.modulate = Color("42ffffff")
		
	get_tree().call_group("GeneralOutline","_visible",general_outline)

func _on_Snap_button_down():
	Sound._play("Select")
	$SnapImage.modulate = Color("42ffffff")

func _on_Snap_button_up():
	if snap == false:
		snap = true
		$SnapImage.modulate = Color("a9ffffff")
	else:
		snap = false
		$SnapImage.modulate = Color("42ffffff")
		
	get_tree().call_group("Main","_snap",snap)

func _on_Scale_button_down():
	Sound._play("Select")
	$ScaleImage.modulate = Color("42ffffff")

func _on_Scale_button_up():
	Sound._play("Change")
	if scaling == false:
		scaling = true
		$ScaleImage.modulate = Color("a9ffffff")
	else:
		scaling = false
		$ScaleImage.modulate = Color("42ffffff")
		
	get_tree().call_group("Main","_scale",scaling)

func _on_Inspector_button_down():
	Sound._play("Select")

func _on_Inspector_button_up():
	get_parent()._inspector()

func _on_Duplicate_button_down():
	Sound._play("Select")
	$DuplicateImage.modulate = Color("42ffffff")

func _on_Duplicate_button_up():
	
	if root.focus == false:
		Notice._show("duplicate_error")
	else:
		Sound._play("HideMenu")
		root._duplicate_object()
	
	$DuplicateImage.modulate = Color("a9ffffff")

func _on_Remove_button_down():
	Sound._play("Select")
	$RemoveImage.modulate = Color("42ffffff")

func _on_Remove_button_up():
	
	if root.focus == false:
		Notice._show("duplicate_error")
	else:
		Sound._play("CloseOld")
		root._remove_object(root.selected)
	
	$RemoveImage.modulate = Color("a9ffffff")

func _on_Check_button_down():
	Sound._play("Select")
	$CheckImage.modulate = Color("42ffffff")

func _on_Check_button_up():
	if check == false:
		check = true
		$CheckImage.modulate = Color("a9ffffff")
	else:
		check = false
		$CheckImage.modulate = Color("42ffffff")
		
	get_tree().call_group("Main","_check",check)

func _on_Preview_button_down():
	Sound._play("Select")
	$PreviewImage.modulate = Color("a9ffffff")

func _on_Preview_button_up():
	if preview == false:
		preview = true
		$PreviewImage.modulate = Color("42ffffff")
	else:
		preview = false
		$PreviewImage.modulate = Color("42ffffff")
		
	get_tree().call_group("Main","_preview",preview)

func _on_Quick_button_down():
	Sound._play("Select")

func _on_Quick_button_up():
	root._quicktest()
