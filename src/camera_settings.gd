extends Node

signal change_camera(node : Node2D)

signal update_hp(new_hp : float, max_hp : float)
signal update_fuel(new_fuel : float, max_fuel : float)

var target : Node2D


func _on_camera_change(node):
	change_camera.emit(node)
	
func _on_update_hp(new_hp, max_hp):
	update_hp.emit(new_hp, max_hp)
	
func _on_update_fuel(new_fuel, max_fuel):
	update_fuel.emit(new_fuel, max_fuel)
	
