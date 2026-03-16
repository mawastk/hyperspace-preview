extends Node2D

func _play(sound : String):
	get_node(sound).play()

func _stop(sound : String):
	get_node(sound).stop()
