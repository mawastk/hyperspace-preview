extends Node

func _check_nominus(value : float):
	if value > 0:
		return value
	else:
		return 0.01
		
func _check_nominus_allowedzero(value : float):
	if value > 0:
		return value
	else:
		return 0

func _check_tilerange(value : int):
	if value < 0:
		return 0
	elif value > 63:
		return 63
	else:
		return value

func _check_rawcolor(value : float):
	if value < 0:
		return 0.001
	elif value > 1.0:
		return 1.0
	else:
		return value
