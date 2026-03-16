extends Node2D

onready var guide = get_node("%MakeGuide")
onready var root = get_node("../../")

var pressed = false

var object = ""

var area = {
	box = [
		Vector2(586, 124),
		Vector2(643, 181)
	],
	decal = [
		Vector2(510, 140),
		Vector2(565, 195)
	],
	powerup = [
		Vector2(440, 123),
		Vector2(492, 178)
	],
	scoretop = [
		Vector2(390, 68),
		Vector2(445, 124)
	],
	bar = [
		Vector2(377, 0),
		Vector2(432, 58)
	]
}

func _physics_process(_delta):
	
	var pos = Vector3(
		guide.get_node("Guide").translation.x,
		guide.get_node("Guide").translation.y,
		guide.get_node("Guide").translation.z
	)
	
	get_parent().get_node("Addcover/Addpos").text = str(pos.x) + " x " + str(pos.y) + " x " + str(pos.z)

func _select(item : String):
	
	if item == "":
		return
	
	object = item
	
	if item == "box":
		guide._mode("normal")
	else:
		guide._mode("cross")
	
	if get_node("%Inspector").active == true:
		get_node("%Inspector")._close()
	
	root.get_node("Override/Gizmo").hide()
	root._block(true)
	
	guide.get_node("Guide").show()
	
	get_parent().get_node("Addcover/AddCoverAnimation").stop()
	get_parent().get_node("Addcover/AddCoverAnimation").play("Show")
	
	Sound._play("CloseOld")

func _on_Add_button_down():
	
	pressed = true
	
	Sound._play("ShowOld")
	
	$AddImageAnimation.stop()
	$AddImageAnimation.play("Push")
	
	get_node("%Camera").block = true
	
	yield($AddImageAnimation, "animation_finished")
	
	if pressed == true:
		$AddImageAnimation.play("Shake")
		Sound._play("Homing")

func _on_Add_button_up():
	
	pressed = false
	
	get_node("%Camera").block = false
	
	Sound._stop("Homing")
	
	$AddImageAnimation.stop()
	$AddImageAnimation.play("Release")
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var selected = ""
	
	if MouseChecker._check(mouse_pos, area.box[0], area.box[1]):
		selected = "box"
	if MouseChecker._check(mouse_pos, area.decal[0], area.decal[1]):
		selected = "decal"
	if MouseChecker._check(mouse_pos, area.powerup[0], area.powerup[1]):
		selected = "powerup"
	if MouseChecker._check(mouse_pos, area.scoretop[0], area.scoretop[1]):
		selected = "scoretop"
	if MouseChecker._check(mouse_pos, area.bar[0], area.bar[1]):
		selected = "bar"
	
	if selected == "bar":
		GlobalPopup._pop("ObstacleLoader")
		return
	
	_select(selected)

func _popup(window : String, action : String, arg):
	
	if window == "ObstacleLoader":
		if action == "Select":
			
			_select(arg)

func _on_Complete_button_down():
	Sound._play("Select")

func _on_Complete_button_up():
	
	if object == "box":
		root._add_object("box", guide.get_node("Guide").translation)
		
	if object == "decal":
		root._add_object("decal", guide.get_node("Guide").translation)
		
	elif object == "powerup":
		root._add_object("powerup", guide.get_node("Guide").translation)
		
	elif object == "scoretop":
		root._add_object("score", guide.get_node("Guide").translation)
		
	elif object in ["bar", "sweeper", "foldwindow", "beatwindow", "rotor", "revolver"]:
		root._add_object(object, guide.get_node("Guide").translation)
	
	get_parent().get_node("Addcover/AddCoverAnimation").stop()
	get_parent().get_node("Addcover/AddCoverAnimation").play("Hide")
	
	guide.get_node("Guide").hide()
	
	root._block(false)
	
	Sound._play("HideMenu")

func _on_Cancel_button_down():
	Sound._play("Select")

func _on_Cancel_button_up():
	
	get_parent().get_node("Addcover/AddCoverAnimation").stop()
	get_parent().get_node("Addcover/AddCoverAnimation").play("Hide")
	
	guide.get_node("Guide").hide()
	
	root._block(false)
	
	Sound._play("HideMenu")

