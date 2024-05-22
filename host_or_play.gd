extends Control

signal back(curr : Control)

func _on_back_button_pressed(_button : Control):
	back.emit(self)
	pass # Replace with function body.
