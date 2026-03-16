extends Node2D

var argument
var open = false
var open_window = ""

# 注意
# 各popupへの_reset()はそのポップアップを表示するとき以外には行わないでください
# また、Quicktestは_reset()をトリガーにタイマーを開始して、自動的にエクスポートします

func _ready():
	#_pop("ObstacleLoader", ["basic_glass", "aa"])
	pass

func _pop(window : String, arg = 0):
	
	argument = arg
	
	for i in range($CanvasLayer/Popup.get_child_count()):
		$CanvasLayer/Popup.get_child(i).hide()
	
	$CanvasLayer/Popup.get_node(window).show()
	$CanvasLayer/Popup.get_node(window)._reset()
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Show")
	
	open_window = window
	
	open = true
	Sound._play("Show")

func _send(window : String, action : String, arg):
	get_tree().call_group("Popup","_popup",window, action, arg)
	_close()

func _close():
	open = false
	Sound._play("Close")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Hide")

func _on_R_value_changed(value):
	Sound._play("Dot")

func _on_G_value_changed(value):
	Sound._play("Dot")

func _on_B_value_changed(value):
	Sound._play("Dot")
