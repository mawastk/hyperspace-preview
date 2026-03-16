extends Node2D

func _change_scene(scene : String):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Change")
	yield($AnimationPlayer, "animation_finished")
	var _rt = get_tree().change_scene(scene)
	$AnimationPlayer.stop()
	$AnimationPlayer.play_backwards("Change")
