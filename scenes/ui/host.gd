extends Control

signal host
signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	for map : MapParams in Maps.maps: 
		var new_scene : PackedScene = preload("res://scenes/ui/MapPanel.tscn")
		var new_panel : MapPanel = new_scene.instantiate()
		new_panel.map = map
		$MarginContainer/Panel/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/ScrollContainer/Maps.add_child(new_panel)
	
	for powerup : PowerupParams in Powerups.powerups: 
		var new_scene : PackedScene = preload("res://scenes/ui/PowerUpPanel.tscn")
		var new_panel : PowerupPanel = new_scene.instantiate()
		new_panel.powerup = powerup
		$MarginContainer/Panel/MarginContainer/VBoxContainer/GridContainer/VBoxContainer/VBoxContainer/ScrollContainer/Powerups.add_child(new_panel)
	
	pass # Replace with function body.


func _on_back_button_pressed():
	back.emit()
	pass # Replace with function body.


func _on_start_button_pressed():
	print("hi")
	host.emit()
	pass # Replace with function body.
