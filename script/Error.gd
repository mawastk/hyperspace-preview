extends Node

class_name Error

var error = []

var error_text = {
	NoTemplateBox = "Warning: Since no template has been assigned to the box, \"None\" has been assigned.",
	NoPositionBox = "Error: The box has been reset to 0,0,0 because no position was assigned to it.",
	NoSizeBox = "Error: The box has been reset to 1,1,1 because no size was assigned to it.",
	NoPositionPowerup = "Error: The powerup has been reset to 0,0,0 because no position was assigned to it.",
	NoTypePowerup = "Error: Reset to ballfrenzy due to invalid power-up type."
}

func _add_error(error_arg : String):
	error.append(error_arg)
