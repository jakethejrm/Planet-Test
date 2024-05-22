extends Control

signal back(curr : Control)

@export var parent : Control

func _on_exit_button_pressed():
	back.emit(self)
	pass # Replace with function body.
