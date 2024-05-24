extends Control

signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	for map : MapParams in Maps.maps: 
		var new_scene : PackedScene = preload("res://scenes/ui/MapPanel.tscn")
		var new_panel = new_scene.instantiate()
		new_panel.map = map
		$MarginContainer/Panel/MarginContainer/VBoxContainer/GridContainer/VBoxContainer2/ScrollContainer/Maps.add_child(new_panel)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	back.emit()
	pass # Replace with function body.
