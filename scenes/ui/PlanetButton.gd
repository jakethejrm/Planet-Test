@tool
extends Control

signal button_pressed(button : Control)

@export var text : String = "" : set = _set_button_text
@export var planet_color : Color = Color.WHITE : set = _set_planet_color
@export var icon: Texture2D = PlaceholderTexture2D.new() : set = _set_icon
@export var orbit_speed : float = 1
@export var pitch : float = 1
@export var sub_planets : Array[Control] = []
var hovered = false;

@export var active = false

var planet_scale : float = 1.0 : set = _set_planet_scale

# Ellipse Radius Vars
var a : float = 200.0
var b : float = 40.0

# Used for orbiting planet buttons
var time_offset : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var num_subplanets = sub_planets.size()
	for index in range(num_subplanets):
		sub_planets[index].connect("button_pressed", _on_planet_pressed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var num_subplanets = sub_planets.size()
	for index in range(num_subplanets):
		var angle : float = float(index+1)/num_subplanets * (2.0 * PI) + time_offset + (delta * orbit_speed)
		sub_planets[index].global_position = global_position + ellipse_point(angle)
		if sub_planets[index].global_position.y < global_position.y:
			sub_planets[index].z_index = -(index + 1)
		else:
			sub_planets[index].z_index = index + 1
		var scale_factor = remap(sub_planets[index].global_position.y - global_position.y, -40.0, 40.0, .5, 1)
		if sub_planets[index].hovered == true:
			scale_factor = scale_factor + 0.25
		sub_planets[index].planet_scale = scale_factor
	time_offset += (delta * orbit_speed)
	pass # Replace with function body.

func ellipse_point(angle) -> Vector2:
	var x = a * cos(angle)
	var y = b * sin(angle)
	return Vector2(x, y)	

func _set_button_text(new_text : String) -> void:
	text = new_text
	$ButtonName.text = new_text

func _set_planet_color(new_color : Color) -> void:
	planet_color = new_color
	$Planet.modulate = new_color

func _set_icon(new_icon : Texture2D) -> void:
	icon = new_icon
	$Icon.texture = new_icon as Texture2D

func _set_planet_scale(new_scale : float):
	planet_scale = new_scale
	$Icon.scale = Vector2(new_scale, new_scale)
	$Planet.scale = Vector2(new_scale, new_scale)


func _on_planet_mouse_entered():
	hovered = true
	$Planet/HoverGradient.show()
	$Planet/Particles.emitting = true
	$Planet/HoverSound.pitch_scale = pitch * randf_range(.99, 1.01)
	$Planet/HoverSound.play()
	pass # Replace with function body.


func _on_planet_mouse_exited():
	hovered = false
	$Planet/HoverGradient.hide()
	$Planet/Particles.emitting = false
	pass # Replace with function body.

func _on_planet_pressed(node : Control = null):
	if node:
		button_pressed.emit(node)
	else:
		button_pressed.emit(self)
	pass # Replace with function body.
