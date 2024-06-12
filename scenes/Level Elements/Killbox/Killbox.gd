extends Area2D


# Called when the node enters the scene tree for the first time.
func _killbox():
	pass


func _on_area_entered(area):
	if(area.name == "Hurtbox"):
		area.get_parent().killbox_damage(self)
