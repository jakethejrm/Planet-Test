extends Control

@onready var max_hp_width : float = $Margins/VBoxContainer/BG/health.size.x
@onready var max_fuel_width : float = $Margins/VBoxContainer/Fuel/fuel.size.x
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_fuel(new_fuel, max_fuel):
	$Margins/VBoxContainer/Fuel/fuel.size.x = new_fuel/max_fuel * max_fuel_width
	pass # Replace with function body.


func _on_player_update_hp(new_hp, max_hp):
	$Margins/VBoxContainer/BG/health.size.x = new_hp/max_hp * max_hp_width
