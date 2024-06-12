extends Control

signal host(lobby_name : String, player_count : int)
signal join_lobby(lobby_id : int)
signal back(curr : Control)

@export var join_menu : Control
@export var host_menu : Control

func _on_back_button_pressed(_button : Control):
	back.emit(self)
	pass # Replace with function body.

func _on_join_button_pressed(_button):
	$Menu.hide()
	join_menu.show()
	join_menu.fetch_lobbies()
	pass # Replace with function body.


func _on_host_button_pressed(_button):
	$Menu.hide()
	host_menu.show()
	pass # Replace with function body.


func _on_join_back():
	$Menu.show()
	join_menu.hide()
	
	pass # Replace with function body.


func _on_host_back():
	$Menu.show()
	host_menu.hide()
	pass # Replace with function body.

func _on_join_lobby(lobby_id):
	join_lobby.emit(lobby_id)
	pass # Replace with function body.


func _on_host_host(lobby_name, player_count):
	print("hi2")
	host.emit(lobby_name, player_count)
	pass # Replace with function body.
