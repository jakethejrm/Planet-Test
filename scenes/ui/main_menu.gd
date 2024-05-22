extends Control



@export var play_menu : Control
@export var settings_menu : Control
@export var cosmetics_menu : Control
@export var stats_menu : Control

@onready var root_planet_button = $MenuOptions/Margins/MarginContainer/SelectMenu/PlanetButton
@onready var transition_screen : ColorRect = $Camera/TransitionScreen
@onready var transition_handler : AnimationPlayer = $Camera/TransitionScreen/TransitionHandler
@onready var camera : Camera2D = $Camera

var menu_to_show : Control
var menu_to_hide : Control

var where_to_zoom : Control = null

func _on_planet_button_pressed(button : Control):
	where_to_zoom = button
	match button.name:
		"Play":
			transition_scene(play_menu)
			pass
		"Settings":
			transition_scene(settings_menu)
			pass
		"Quit":
			transition_scene()
			pass
		"Cosmetics":
			transition_scene(cosmetics_menu)
			pass
		"Stats":
			transition_scene(stats_menu)
			pass
	pass # Replace with function body.

func transition_scene(next_menu : Control = null, curr : Control = $MenuOptions):
	transition_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	menu_to_show = next_menu
	menu_to_hide = curr
	transition_handler.current_animation = "fade_out"
	root_planet_button.orbit_speed = 0.0
	# tween to zoom into planet option:
	var tween1 : Tween = get_tree().create_tween()
	tween1.tween_property(camera, "global_position", where_to_zoom.global_position, 0.5)
	
	var tween2 : Tween = get_tree().create_tween()
	var new_zoom : Vector2 = Vector2(where_to_zoom.scale.x, where_to_zoom.scale.y)
	tween2.tween_property(camera, "zoom", new_zoom, 0.5)
	
	transition_handler.play()
	pass


func _on_transition_handler_animation_finished(anim_name : String):
	if anim_name == "fade_out":
		root_planet_button.orbit_speed = 0.1
		if not menu_to_show:
			get_tree().quit()
		else:
			menu_to_hide.hide()
			menu_to_show.show()
			transition_handler.current_animation = "fade_in"
			
			camera.global_position = Vector2(320, 180)
			#
			#var tween2 : Tween = get_tree().create_tween()
			#tween2.tween_property(camera, "zoom", Vector2.ONE, 0.5)
			transition_handler.play()
	
	else:
		
		transition_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		

func _on_back(curr):
	transition_scene($MenuOptions, curr)

