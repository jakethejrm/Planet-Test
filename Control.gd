extends Control


var num_dots : int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	num_dots = (num_dots + 1)
	if num_dots % 4 == 0:
		$Camera/MarginContainer/HBoxContainer/LoadingDots.text = ""
	else:
		$Camera/MarginContainer/HBoxContainer/LoadingDots.text += "."
	
