class_name PowerupPanel extends PanelContainer

@export var powerup : PowerupParams : set = _set_powerup_params
var selected : bool = true : set = _set_selected

func _set_powerup_params(new_powerup : PowerupParams):
	powerup = new_powerup
	
	$MarginContainer/BoxContainer/Label.text = powerup.powerup_name
	if powerup.powerup_pic:
		var texture = ImageTexture.new()
		texture = powerup.powerup_pic
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
