class_name MapPanel extends PanelContainer

@export var map : MapParams : set = _set_map_params
var selected : bool = true : set = _set_selected

func _set_map_params(new_map : MapParams):
	map = new_map
	
	$MarginContainer/BoxContainer/Label.text = map.map_name
	if map.map_pic:
		var texture = ImageTexture.new()
		texture = map.map_pic
		$MarginContainer/BoxContainer/TextureRect.texture = texture

func _set_selected(new : bool):
	selected = new
	if new:
		$MarginContainer/MarginContainer/Check.show()
		$ColorRect.hide()
	else:
		$MarginContainer/MarginContainer/Check.hide()
		$ColorRect.show()

func _on_button_pressed():
	selected = !selected
	pass # Replace with function body.
