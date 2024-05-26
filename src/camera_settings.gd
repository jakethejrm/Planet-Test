extends Node

signal change_camera(node : Node2D)

func _on_camera_change(node):
	change_camera.emit(node)
	
