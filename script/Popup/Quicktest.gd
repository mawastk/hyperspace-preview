extends Node2D

func _reset():
	$Timer.start()

func _on_Timer_timeout():
	get_node("../../../")._send(self.name, "Complete", [])
